{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Shortblito.Web.Server where

import Control.Monad
import Control.Monad.Logger
import Database.Persist.Sql
import Database.Persist.Sqlite
import Shortblito.Database
import Shortblito.Web.Server.Application ()
import Shortblito.Web.Server.Constants
import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.OptParse
import Shortblito.Web.Server.Static
import Text.Show.Pretty
import Yesod

shortblitoWebServer :: IO ()
shortblitoWebServer = do
  settings <- getSettings
  when development $ pPrint settings
  runShortblitoWebServer settings

runShortblitoWebServer :: Settings -> IO ()
runShortblitoWebServer Settings {..} =
  runStderrLoggingT $
    withSqlitePool "urls.db" 1 $ \pool -> do
      let app =
            App
              { appLogLevel = settingLogLevel,
                appStatic = shortblitoWebServerStatic,
                appConnectionPool = pool,
                appGoogleAnalyticsTracking = settingGoogleAnalyticsTracking,
                appGoogleSearchConsoleVerification = settingGoogleSearchConsoleVerification
              }
      flip runSqlPool pool $ runMigration migrateTables
      liftIO $ Yesod.warp settingPort app
