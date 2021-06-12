{-# LANGUAGE OverloadedStrings #-}

module Shortblito.Web.Server.Handler.ElongatorSpec (spec) where

import Shortblito.Web.Server.Handler.TestImport

spec :: Spec
spec = shortblitoWebServerSpec $
  ydescribe "ElongatorR" $ do
    yit "can report invalid key" $ do
      get $ ElongatorR "$"
      statusIs 400
    yit "can retrieve shortened url" $ do
      postBody ShortenerR "https://www.pabloproductions.be/"
      get $ ElongatorR "a"
      statusIs 301
    yit "can report not found" $ do
      get $ ElongatorR "a"
      statusIs 404
