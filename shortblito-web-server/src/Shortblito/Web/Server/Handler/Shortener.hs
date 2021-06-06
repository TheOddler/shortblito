{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Shortblito.Web.Server.Handler.Shortener where

import Data.Text (Text)
import Shortblito.Web.Server.Handler.Import
import Yesod (redirect)

getShortenerR :: String -> Handler Html
getShortenerR short = defaultLayout [whamlet|<div>Hello #{short}|] -- redirect "https://duckduckgo.com/?t=ffab&q=test&ia=web"
