{-# LANGUAGE OverloadedStrings #-}

module Shortblito.Web.Server.Handler.HomeSpec (spec) where

import Shortblito.Web.Server.Handler.TestImport

spec :: Spec
spec = shortblitoWebServerSpec $
  ydescribe "ShortenerR" $
    yit "GETs a 200" $
      do
        get ShortenerR
        statusIs 200
