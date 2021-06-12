{-# LANGUAGE OverloadedStrings #-}

module Shortblito.Web.Server.Handler.ShortenerSpec (spec) where

import Shortblito.Web.Server.Handler.TestImport

spec :: Spec
spec = shortblitoWebServerSpec $
  ydescribe "ShortenerR" $ do
    yit "can show homepage" $ do
      get ShortenerR
      statusIs 200
    yit "can shorten url" $ do
      postBody ShortenerR "https://www.pabloproductions.be/"
      statusIs 200
    yit "can shorten with prefix" $ do
      postBody ShortenerR "long=https://duckduckgo.com/"
      statusIs 200
    yit "can report empty url" $ do
      postBody ShortenerR ""
      statusIs 400
    yit "can report empty url with prefix" $ do
      postBody ShortenerR "long="
      statusIs 400
    yit "can report non-url" $ do
      postBody ShortenerR "not a real url"
      statusIs 400
    yit "can report non-url with prefix" $ do
      postBody ShortenerR "long=nourl"
      statusIs 400
