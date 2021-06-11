{-# LANGUAGE OverloadedStrings #-}

module Shortblito.Web.Server.Handler.ShortenerSpec (spec) where

import Shortblito.Web.Server.Handler.TestImport

spec :: Spec
spec = shortblitoWebServerSpec $
  ydescribe "ShortenerR" $ do
    yit "Home page exists" $ do
      get ShortenerR
      statusIs 200
    yit "Post to shorten" $ do
      postBody ShortenerR "test" -- "https://www.pabloproductions.be/"
      statusIs 200