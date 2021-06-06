{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}

module Shortblito.Web.Server.Handler.Shortener where

import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Read (decimal)
import Database.Persist
import Database.Persist.Sql
import Database.Persist.Sqlite
import Database.Persist.TH
import qualified Network.HTTP.Types as H
import Shortblito.Database
import Shortblito.Web.Server.Handler.Import
import Yesod (redirectWith)

getShortenerR :: UrlId -> Handler Html
getShortenerR short = do
  mUrl <- runDB $ get short
  case mUrl of
    Nothing -> notFound --redirectWith status ("https://duckduckgo.com/" :: Text)
    Just u -> redirectWith status $ urlLong u
  where
    status = H.status302 -- temporarily use 302 instead of 301 for testing, otherwise your browser will cache the redirect
