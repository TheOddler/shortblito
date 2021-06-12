{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Shortblito.Web.Server.Handler.Elongator (getElongatorR) where

import Database.Persist.Sql (toSqlKey)
import Network.HTTP.Types (status301)
import Shortblito.BaseChanging
import Shortblito.Database
import Shortblito.Web.Server.Constants
import Shortblito.Web.Server.Handler.Import
import Yesod (redirectWith)

getElongatorR :: String -> Handler Html
getElongatorR short =
  case shortToUrlId short of
    Nothing -> invalidArgs [invalidKeyErrorMsg] -- defaultLayout [whamlet|<div>Failed parsing key|]
    Just key -> do
      mUrl <- runDB $ get key
      case mUrl of
        Nothing -> notFound -- defaultLayout [whamlet|<div>Parsed key to: #{show key}, but no long found|]
        Just u -> redirectWith status301 $ urlLong u -- defaultLayout [whamlet|<div>Parsed key to: #{show key}, this will redirect to: #{urlLong u}|]

shortToUrlId :: String -> Maybe UrlId
shortToUrlId short = toSqlKey . fromIntegral <$> fromBase short
