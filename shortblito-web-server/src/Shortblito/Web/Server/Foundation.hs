{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Shortblito.Web.Server.Foundation where

import Data.FileEmbed (makeRelativeToProject)
import Data.Text (Text)
import Database.Persist.Sql
import Shortblito.KeyShortening
import Shortblito.Database
import Shortblito.Web.Server.Widget
import Text.Hamlet
import Yesod
import Yesod.EmbeddedStatic

data App = App
  { appLogLevel :: !LogLevel,
    appStatic :: !EmbeddedStatic,
    appConnectionPool :: !ConnectionPool,
    appGoogleAnalyticsTracking :: !(Maybe Text),
    appGoogleSearchConsoleVerification :: !(Maybe Text)
  }

mkYesodData "App" $(makeRelativeToProject "routes.txt" >>= parseRoutesFile)

instance Yesod App where
  shouldLogIO app _ ll = pure $ ll >= appLogLevel app
  defaultLayout widget = do
    app <- getYesod
    pageContent <- widgetToPageContent $(widgetFile "default-body")
    withUrlRenderer $(makeRelativeToProject "templates/default-page.hamlet" >>= hamletFile)

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB func = do
    pool <- getsYesod appConnectionPool
    runSqlPool func pool
