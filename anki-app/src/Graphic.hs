module Graphic where

import Graphics.Gloss.Interface.Pure.Game
import Menu
import Card
import Time


drawMenu :: Menu -> Picture
drawMenu translate x y (Pictures [drawList menu, drawSet menu])
    where
        x = -fromIntegral (width menu)  / 2
        y = -fromIntegral (height menu) / 2

drawList :: Menu -> Picture

drawSet :: Menu -> Picture
