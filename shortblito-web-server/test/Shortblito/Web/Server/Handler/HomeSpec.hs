module Shortblito.Web.Server.Handler.HomeSpec (spec) where

import Shortblito.Web.Server.Handler.TestImport

spec :: Spec
spec = shortblitoWebServerSpec $
  ydescribe "HomeR" $
    yit "GETs a 200" $
      do
        get HomeR
        statusIs 200
