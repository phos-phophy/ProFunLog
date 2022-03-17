module Gameplay where

import System.Directory
import Graphics.Gloss.Interface.Pure.Game
import Card
import Graphic
import Menu


handleEvent :: Event -> Menu -> Menu
handleEvent _ m = m

menuUpdate :: Float -> Menu -> Menu
menuUpdate _ m = m

displayMenu :: Menu -> IO()
display menu = play (display menu) color fps menu drawMenu handleEvent menuUpdate where 
    display menu = FullScreen
    color = white
    fps = 1


run :: IO()
run = do
    menu <- readMenu "sets/"
    displayMenu menu
    
