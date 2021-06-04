{-# LANGUAGE RecordWildCards #-}

module Shortblito.Web.Server where

import Control.Monad
import Shortblito.Web.Server.Application ()
import Shortblito.Web.Server.Constants
import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.OptParse
import Shortblito.Web.Server.Static
import Text.Show.Pretty
import Yesod

shortblitoWebServer :: IO ()
shortblitoWebServer = do
  sets <- getSettings
  when development $ pPrint sets
  runShortblitoWebServer sets

runShortblitoWebServer :: Settings -> IO ()
runShortblitoWebServer Settings {..} = do
  let app =
        App
          { appLogLevel = settingLogLevel,
            appStatic = shortblitoWebServerStatic,
            appGoogleAnalyticsTracking = settingGoogleAnalyticsTracking,
            appGoogleSearchConsoleVerification = settingGoogleSearchConsoleVerification
          }
  Yesod.warp settingPort app
