module Graphic where

import Graphics.Gloss.Interface.Pure.Game
import State
import Card

collectionHeight :: Float
collectionHeight = 70

collectionWidth :: Float
collectionWidth = 400

collection_x :: Float
collection_x = (-collectionWidth / 2) - 20

collection_y :: Float
collection_y = 400 - (collectionHeight / 2)


drawState :: State -> Picture
drawState st = Pictures [drawMenu st, dividingLine, drawSelectedCollection st]
    where
        x = -fromIntegral (width st) / 2
        y = -fromIntegral (height st) / 2
        dividingLine = Line [(0, 10000), (0, -10000)]

drawMenu :: State -> Picture
drawMenu st = Translate 0 (- (cur_y st)) $ Pictures $ map (\(ind, pic) -> Translate 0 (-ind * 80) pic) $ zip indx $ map drawCollection (collections st)
    where
        indx = [0..] :: [Float]

drawCollection :: CardCollection -> Picture
drawCollection cc = Translate collection_x collection_y $ 
                              Pictures [rectangleWire collectionWidth collectionHeight, 
                              Translate (-collectionWidth / 2) (-collectionHeight / 4) $ scale 0.3 0.3 $ color black $ text (name cc), 
                              Translate (collectionWidth / 2) 0 $ scale 0.2 0.2 $ color red $ text $ show (count cc)]

drawSelectedCollection :: State -> Picture
drawSelectedCollection st = Line [(0, 0), (0, 100)] 

drawSettingsList :: CardCollection -> Picture  -- edit, remove
drawSettingsList cs = rectangleWire 10 20

drawCardSettings :: CardCollection -> Picture  -- editing card
drawCardSettings cs = rectangleWire 10 20
