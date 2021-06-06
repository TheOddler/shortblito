{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Shortblito.Database where

import Data.Text (Text)
import Database.Persist.Sql
import Database.Persist.Sqlite
import Database.Persist.TH

share
  [mkPersist sqlSettings, mkMigrate "migrateTables"]
  [persistLowerCase|
Url
  long Text

  UniqueLong long
  deriving Show
|]

-- main = runSqlite ":memory:" $ runMigration migrateTables

-- buildDb = do
--   runMigration migrateTables
--   insert $ Url "https://www.pabloproductions.be/"
--   insert $ Url "https://github.com/NorfairKing/template-web-server"
--   insert $ Url "https://www.pabloproductions.be/cv"
