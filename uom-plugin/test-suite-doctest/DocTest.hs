module Main (main) where

import Test.DocTest (doctest)

arguments :: [String]
arguments =
    [ "-isrc"
    , "../src/Data/UnitsOfMeasure/Tutorial.hs"
    ]

main :: IO ()
main = doctest arguments
