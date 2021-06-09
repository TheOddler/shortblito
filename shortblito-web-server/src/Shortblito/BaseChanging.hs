module Shortblito.BaseChanging (fromBase, toBase) where

import Data.List (elemIndex, genericIndex)
import Data.Maybe (fromJust, listToMaybe)
import Numeric (readInt, showIntAtBase)

digits :: [Char]
digits = "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-"

base :: Integral i => i
base = fromIntegral $ length digits

validDigit :: Char -> Bool
validDigit = flip elem digits

digitToInt :: Char -> Int
digitToInt c = fromJust $ elemIndex c digits

intToDigit :: Int -> Char
intToDigit = (!!) digits

fromBase :: (Num i, Integral i) => String -> Maybe i
fromBase encoded = fst <$> (listToMaybe . readInt base validDigit digitToInt) encoded

toBase :: (Integral i, Show i) => i -> String
toBase num = showIntAtBase base intToDigit num ""
