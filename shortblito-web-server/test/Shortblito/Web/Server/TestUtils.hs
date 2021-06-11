{-# LANGUAGE OverloadedStrings #-}

module Shortblito.Web.Server.TestUtils where

import Control.Monad.Logger
import Database.Persist.Sql
import Database.Persist.Sqlite
import Shortblito.Database
import Shortblito.Web.Server.Application ()
import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.Static
import Test.Hspec
import Yesod.Test

type ShortblitoWebServerSpec = YesodSpec App

type ShortblitoWebServerExample = YesodExample App

shortblitoWebServerSpec :: ShortblitoWebServerSpec -> Spec
shortblitoWebServerSpec =
  yesodSpecWithSiteGenerator $ -- maybe use yesodSpecWithSiteGeneratorAndArgument later if needed
    runNoLoggingT $
      withSqlitePool ":memory:" 1 $ \pool -> do
        let app =
              App
                { appLogLevel = LevelWarn,
                  appStatic = shortblitoWebServerStatic,
                  appConnectionPool = pool,
                  appGoogleAnalyticsTracking = Nothing,
                  appGoogleSearchConsoleVerification = Nothing
                }
        flip runSqlPool pool $
          do
            runMigration migrateTables
        pure app