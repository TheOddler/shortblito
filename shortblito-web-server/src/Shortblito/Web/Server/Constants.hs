{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Shortblito.Web.Server.Constants where

import Data.Text (Text, append, intercalate)
import Language.Haskell.TH
import System.Environment

development :: Bool
development =
  $( do
       md <- runIO $ lookupEnv "DEVELOPMENT"
       fmap ConE $ case md of
         Nothing -> pure 'False
         Just _ -> do
           runIO $ putStrLn "WARNING: BUILDING IN DEVELOPMENT MODE"
           pure 'True
   )

validUrlPrefixes :: [Text]
validUrlPrefixes = ["http://", "https://"]

invalidUrlErrorMsg :: Text
invalidUrlErrorMsg = "Invalid url given, must start with one of: " `append` intercalate ", " validUrlPrefixes

noBodyFoundErrorMsg :: Text
noBodyFoundErrorMsg = "No request body found"

invalidKeyErrorMsg :: Text
invalidKeyErrorMsg = "Invalid key"
