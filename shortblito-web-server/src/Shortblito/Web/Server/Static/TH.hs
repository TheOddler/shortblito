module Shortblito.Web.Server.Static.TH
  ( mkStatic,
  )
where

import Shortblito.Web.Server.Constants
import Language.Haskell.TH
import Yesod.EmbeddedStatic

mkStatic :: Q [Dec]
mkStatic =
  mkEmbeddedStatic
    development
    "shortblitoWebServerStatic"
    []
