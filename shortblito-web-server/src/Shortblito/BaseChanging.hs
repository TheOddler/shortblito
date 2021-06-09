module Shortblito.BaseChanging where

import Data.List (elemIndex)
import Data.Maybe (fromJust, listToMaybe)
import Numeric (readInt, showIntAtBase)

digits :: [Char]
digits = "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-"

base :: Int
base = length digits

validDigit :: Char -> Bool
validDigit = flip elem digits

digitToInt :: Char -> Int
digitToInt c = fromJust $ elemIndex c digits

intToDigit :: Int -> Char
intToDigit d = digits !! d

fromBase :: Int -> String -> Maybe Int
fromBase base encoded = fst <$> (listToMaybe . readInt base validDigit digitToInt) encoded

toBase :: Int -> Int -> String
toBase base num = showIntAtBase base intToDigit num ""

fromBaseDefault = fromBase base

toBaseDefault = toBase base
