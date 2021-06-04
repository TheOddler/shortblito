module Shortblito.Web.Server.TestUtils where

import Control.Monad.Logger
import Shortblito.Web.Server.Application ()
import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.Static
import Test.Hspec
import Yesod.Test

type ShortblitoWebServerSpec = YesodSpec App

type ShortblitoWebServerExample = YesodExample App

shortblitoWebServerSpec :: ShortblitoWebServerSpec -> Spec
shortblitoWebServerSpec =
  yesodSpec $
    App
      { appLogLevel = LevelWarn,
        appStatic = shortblitoWebServerStatic,
        appGoogleAnalyticsTracking = Nothing,
        appGoogleSearchConsoleVerification = Nothing
      }
