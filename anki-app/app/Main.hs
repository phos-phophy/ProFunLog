module Main where

import Display


main :: IO ()
main = run
    menu <- readMenu
    playMenu menu
