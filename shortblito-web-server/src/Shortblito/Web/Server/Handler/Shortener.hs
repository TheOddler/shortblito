{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}

module Shortblito.Web.Server.Handler.Shortener where

import Database.Persist.Sql (toSqlKey)
import Shortblito.BaseChanging
import Shortblito.Database
import Shortblito.Web.Server.Handler.Import
import Yesod (redirectWith)

getShortenerR :: String -> Handler Html
getShortenerR short =
  case shortToUrlId short of
    Nothing -> defaultLayout [whamlet|<div>Failed parsing key|] -- notFound
    Just key -> do
      mUrl <- runDB $ get key
      case mUrl of
        Nothing -> defaultLayout [whamlet|<div>Parsed key to: #{show key}, but no long found|] -- notFound
        Just u -> defaultLayout [whamlet|<div>Parsed key to: #{show key}, this will redirect to: #{urlLong u}|] -- redirectWith H.status302 $ urlLong u -- temp just show the long url rather than really redirecting

shortToUrlId :: String -> Maybe UrlId
shortToUrlId short = toSqlKey . fromIntegral <$> fromBase short
