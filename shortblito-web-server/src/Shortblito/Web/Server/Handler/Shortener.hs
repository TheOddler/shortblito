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
import Data.Text
import qualified Data.Text as T
import Data.Text.Encoding
import Database.Persist.Sql (fromSqlKey)
import Network.HTTP.Types.URI (urlDecode)
import Shortblito.BaseChanging
import Shortblito.Database
import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.Handler.Import
import Yesod

getShortenerR :: Handler Html
getShortenerR = defaultLayout $(widgetFile "home")

postShortenerR :: Handler Text -- TODO Use something other than Text, or make sure the Text is actually a URL.
postShortenerR = do
  lines <- runConduit $ rawRequestBody .| CT.decode CT.utf8 .| CL.consume
  case parseUrl lines of
    Just longUrl -> do
      existingUrl <- runDB $ getBy $ UniqueLong longUrl
      key <- case existingUrl of
        Just (Entity key _) -> pure key
        Nothing -> do runDB $ insert Url {urlLong = longUrl}
      pure $ pack $ show $ toBase $ fromSqlKey key
    Nothing -> invalidArgs ["long"]

maybeStripPrefix :: Text -> Text -> Text
maybeStripPrefix prefix text = fromMaybe text $ T.stripPrefix prefix text

parseUrl :: [Text] -> Maybe Text
parseUrl [] = Nothing
parseUrl (urlMaybeWithPrefix : _) =
  let url = maybeStripPrefix "long=" urlMaybeWithPrefix
      urlDecoded = decodeUtf8 $ urlDecode False $ encodeUtf8 url
   in if T.null urlDecoded
        then Nothing
        else Just urlDecoded
