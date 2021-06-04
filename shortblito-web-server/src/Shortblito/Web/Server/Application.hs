{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Shortblito.Web.Server.Application where

import Shortblito.Web.Server.Foundation
import Shortblito.Web.Server.Handler

mkYesodDispatch "App" resourcesApp
