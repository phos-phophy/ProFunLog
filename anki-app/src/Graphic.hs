module Graphic where

import Graphics.Gloss.Interface.Pure.Game
import State
import Card


upButton_x :: Float
upButton_x = init_x - collectionWidth / 2 - 40

upButton_y :: Float
upButton_y = init_y - 80

upButton_r :: Float
upButton_r = 30

saveButton_x :: Float
saveButton_x = -init_x - 120

saveButton_y :: Float
saveButton_y = 170

saveButton_w :: Float
saveButton_w = 140

saveButton_h :: Float
saveButton_h = 50


drawState :: State -> IO Picture
drawState st = return $ Pictures [drawLeftMenu st, dividingLine, drawRightMenu st]
    where
        x = -fromIntegral (width st) / 2
        y = -fromIntegral (height st) / 2
        dividingLine = Pictures [Line [(0, 10000), (0, -10000)], Line [(2, 10000), (2, -10000)]]

drawLeftMenu :: State -> Picture
drawLeftMenu st = Pictures [upButton st, addButton st, drawCollectionList st]

drawCollectionList :: State -> Picture
drawCollectionList st = Pictures $ map (drawCollection st) $ dropWhile (\cc -> (y_pos cc) > (init_y - 80) + (cur_y st)) $ collections st

drawCollection :: State -> CardCollection -> Picture
drawCollection st cc = Translate (x_pos cc) ((y_pos cc) - (cur_y st)) $ 
    Pictures [rectangleWire collectionWidth collectionHeight, 
              Translate (-collectionWidth / 2) (-collectionHeight / 8) $ scale 0.3 0.3 $ color black $ text (name cc), 
              Translate (collectionWidth / 2 - 20) (-collectionHeight / 8) $ scale 0.2 0.2 $ color red $ text $ show (count cc)]

addButton :: State -> Picture
addButton _ = Translate init_x init_y $ 
    Pictures [rectangleWire collectionWidth collectionHeight,
              rectangleWire (collectionWidth - 4) (collectionHeight - 4),
              Translate (-collectionWidth / 2) (-collectionHeight / 8) $ scale 0.22 0.22 $ color black $ text "+ Add new card collection"]

upButton :: State -> Picture
upButton st
    | (cur_y st) /= 0 = color black $ Translate upButton_x upButton_y $ Pictures [circ, row]
    | otherwise = color white $ Translate upButton_x upButton_y $ Pictures [circ, row]
    where
        circ = Pictures [Circle upButton_r, Circle (upButton_r - 2)]
        row = Pictures [Line [(0, -20), (0, 25)], Polygon [(0, 25), (-15, 10), (0, 15), (15, 10), (0, 25)]]
        
drawRightMenu :: State -> Picture
drawRightMenu st = case (mode st) of 
    None -> Blank
    AddCardCollection -> Pictures [Translate (-init_x) (init_y - 115) $ rectangleWire collectionWidth 300,
                                   Translate saveButton_x saveButton_y $ rectangleWire saveButton_w saveButton_h,
                                   Translate saveButton_x saveButton_y $ rectangleWire (saveButton_w - 4) (saveButton_h - 4),
                                   Translate (-init_x - 155) 160 $ scale 0.2 0.2 $ color black $ text "Save",
                                   Translate (-init_x - collectionWidth / 2) init_y $ scale 0.2 0.2 $ color black $ text "Enter new collection name:",
                                   Translate (-init_x - collectionWidth / 2) (init_y - 50) $ scale 0.2 0.2 $ color black $ text (newCollectionName st)]
    _ -> Blank

drawSettingsList :: CardCollection -> Picture  -- edit, remove
drawSettingsList cs = rectangleWire 10 20

drawCardSettings :: CardCollection -> Picture  -- editing card
drawCardSettings cs = rectangleWire 10 20
