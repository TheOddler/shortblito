{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Shortblito.KeyShorteningSpec (spec) where

import qualified Data.Text as T
import Shortblito.KeyShortening
import Test.Hspec
import Test.QuickCheck

spec :: Spec
spec =
  describe "KeyShortening" $ do
    it "can shorten 1" $ \_ ->
      toShort (1 :: Int) `shouldBe` "a"
    it "can shorten any positive number" $
      property $ \i ->
        toShort (i :: Word) `shouldSatisfy` \s -> T.length s > 0
    it "can shorten and unshorten any positive number" $
      property $ \i ->
        (fromShort . toShort) (i :: Word) `shouldBe` Just i
    it "can unshorten \"a\"" $ \_ ->
      fromShort "a" `shouldBe` Just (1 :: Int)
    it "cannot unshorten \"$\"" $ \_ ->
      (fromShort "$" :: Maybe Int) `shouldBe` Nothing
    it "can unshorten any text to non-negative number (or Nothing)" $
      property $ \s ->
        (fromShort (T.pack s) :: Maybe Int)
          `shouldSatisfy` ( \case
                              Just i -> i >= 0
                              Nothing -> True
                          )
