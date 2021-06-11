{-# LANGUAGE OverloadedStrings #-}

module Shortblito.Web.Server.Handler.ShortenerSpec (spec) where

import Shortblito.Web.Server.Handler.TestImport

spec :: Spec
spec = shortblitoWebServerSpec $
  ydescribe "ShortenerR" $ do
    yit "can show homepage" $ do
      get ShortenerR
      statusIs 200
    yit "can shorten link" $ do
      postBody ShortenerR "https://www.pabloproductions.be/"
      statusIs 200
