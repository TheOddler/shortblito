{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Shortblito.Web.Server.Handler.Shortener where

import Control.Applicative ((<$>), (<*>))
import Data.Text
import Database.Persist.Sql (fromSqlKey)
import Shortblito.BaseChanging
import Shortblito.Database
import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.Handler.Import
import Yesod

data LongUrl = LongUrl {url :: Text}

instance FromJSON LongUrl where
  parseJSON (Object v) = LongUrl <$> v .: "url"

getShortenerR :: Handler Html
getShortenerR = defaultLayout $(widgetFile "home")

postShortenerR :: Handler Text
postShortenerR = do
  longUrl <- requireCheckJsonBody :: Handler LongUrl -- Foo -- get the json body as Foo (assumes FromJSON instance)
  existingUrl <- runDB $ getBy $ UniqueLong $ url longUrl
  key <- case existingUrl of
    Just (Entity key _) -> pure key
    Nothing -> do runDB $ insert Url {urlLong = url longUrl}
  pure $ pack $ show $ toBase $ fromSqlKey key
