{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Shortblito.Web.Server.Handler.Home where

import Shortblito.Web.Server.Handler.Import

getHomeR :: Handler Html
getHomeR = defaultLayout $(widgetFile "home")
