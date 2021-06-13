module Shortblito.KeyShortening (Short, fromShort, toShort) where

import Data.List (elemIndex, genericIndex)
import Data.Maybe (fromJust, listToMaybe)
import Data.Text (Text, pack, unpack)
import Numeric (readInt, showIntAtBase)

type Short = Text

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

fromShort :: (Num i, Integral i) => Short -> Maybe i
fromShort encoded = fst <$> (listToMaybe . readInt base validDigit digitToInt) (unpack encoded)

toShort :: (Integral i, Show i) => i -> Short
toShort num = pack $ showIntAtBase base intToDigit num ""
