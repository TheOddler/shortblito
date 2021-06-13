{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Shortblito.Web.Server.Handler.Elongator (getElongatorR) where

import Database.Persist.Sql
import Network.HTTP.Types
import Shortblito.Database
import Shortblito.KeyShortening
import Shortblito.Web.Server.Constants
import Shortblito.Web.Server.Handler.Import

getElongatorR :: Short -> Handler Html
getElongatorR short =
  case shortToUrlId short of
    Nothing -> invalidArgs [invalidKeyErrorMsg]
    Just key -> do
      mUrl <- runDB $ get key
      case mUrl of
        Nothing -> notFound
        Just u -> redirectWith status301 $ urlLong u

shortToUrlId :: Short -> Maybe UrlId
shortToUrlId short = toSqlKey <$> fromShort short
