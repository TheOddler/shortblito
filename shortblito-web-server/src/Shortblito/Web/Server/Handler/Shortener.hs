{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Shortblito.Web.Server.Handler.Shortener (getShortenerR, postShortenerR) where

import Control.Applicative ((<$>), (<*>))
import Data.Conduit
import qualified Data.Conduit.List as CL
import qualified Data.Conduit.Text as CT
import Data.Maybe (fromMaybe, listToMaybe)
import Data.Text (Text, append, intercalate, isPrefixOf, pack)
import qualified Data.Text as T
import Data.Text.Encoding
import Database.Persist.Sql (fromSqlKey)
import Network.HTTP.Types.URI (urlDecode)
import Shortblito.BaseChanging
import Shortblito.Database
import Shortblito.Web.Server.Constants
import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.Handler.Import
import Yesod

data Result a
  = Error Text
  | Success a

getShortenerR :: Handler Html
getShortenerR = defaultLayout $(widgetFile "home")

postShortenerR :: Handler Text
postShortenerR = do
  lines <- runConduit $ rawRequestBody .| CT.decode CT.utf8 .| CL.consume
  case parseUrl lines of
    Success longUrl -> do
      existingUrl <- runDB $ getBy $ UniqueLong longUrl
      key <- case existingUrl of
        Just (Entity key _) -> pure key
        Nothing -> runDB $ insert Url {urlLong = longUrl}
      pure $ pack $ toBase $ fromSqlKey key -- return the base-changed key
    Error msg -> invalidArgs [msg]

maybeStripPrefix :: Text -> Text -> Text
maybeStripPrefix prefix text = fromMaybe text $ T.stripPrefix prefix text

-- | Parses the post body to an absolute url if possible.
-- Must be url-encoded, and start with either http or https
parseUrl :: [Text] -> Result Text
parseUrl [] = Error noBodyFoundErrorMsg
parseUrl (urlMaybeWithPrefix : _) =
  let url = maybeStripPrefix formPrefix urlMaybeWithPrefix
      urlDecoded = decodeUtf8 $ urlDecode False $ encodeUtf8 url
   in if hasValidPrefix urlDecoded
        then Success urlDecoded
        else Error invalidUrlErrorMsg

hasValidPrefix :: Text -> Bool
hasValidPrefix url = any (`isPrefixOf` url) validUrlPrefixes
