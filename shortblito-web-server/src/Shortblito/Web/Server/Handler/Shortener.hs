{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Shortblito.Web.Server.Handler.Shortener where

import Data.Text (Text)
import qualified Data.Text as T
import qualified Network.HTTP.Types as H
import Shortblito.Web.Server.Handler.Import
import Yesod (redirectWith)

getShortenerR :: Text -> Handler Html
getShortenerR short = redirectWith status url
  where
    url :: Text
    url = T.append "https://duckduckgo.com/?q=" short
    status = H.status302 -- temporarily use 302 instead of 301 for testing, otherwise your browser will cache the redirect
