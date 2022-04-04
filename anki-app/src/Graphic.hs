module Graphic where

import Graphics.Gloss.Interface.IO.Game
import State
import Card
import Button
import Data.Maybe


drawState :: State -> IO Picture
drawState st = return $ Pictures [drawLeftMenu st, dividingLine, drawRightMenu st]
    where
        dividingLine = Pictures [Line [(0, 10000), (0, -10000)], Line [(2, 10000), (2, -10000)]]


-- menu

drawLeftMenu :: State -> Picture
drawLeftMenu st = Pictures [drawUpButton st, drawButton addButton Blank, drawCollectionList st]

drawRightMenu :: State -> Picture
drawRightMenu st = case (mode st) of 
    AddCardCollection -> Pictures [Translate menuX menuY $ rectangleWire menuWidth menuHeight, 
                                   drawSaveButton st, drawButton cancelButton Blank,
                                   Translate (menuX - menuWidth/2 + pad) (menuY - pad - buttonHeight/2 + menuHeight/2) $ scale 0.2 0.2 $ color black $ text "Enter new collection name:",
                                   Translate (menuX - menuWidth/2 + pad) (menuY - 2*pad - buttonHeight + menuHeight/2) $ scale 0.2 0.2 $ color black $ text (newCollectionName st),
                                   Translate (menuX - menuWidth/2 + pad) (menuY - 3*pad - buttonHeight + menuHeight/2) $ scale 0.2 0.2 $ color black $ text "______________"]
    Select -> Pictures [Translate menuX menuY $ rectangleWire menuWidth menuHeight, drawRightSubMenu st,
                        drawButton cancelButton Blank, drawButton deleteButton Blank, drawButton addCardButton Blank, drawLearnButton st, drawStopButton st, drawChangeNameButton st,
                        Translate (menuX - menuWidth/2 + pad) (menuY - pad - buttonHeight/2 + menuHeight/2) $ scale 0.3 0.3 $ color black $ text $ name $ fromJust $ selectedCollection st]
    _ -> Blank


drawRightSubMenu :: State -> Picture
drawRightSubMenu st = case (submode st) of
    AddCard _ -> drawCardSettings st
    EditCard _ _ -> drawCardSettings st
    Learn _ _-> Pictures [Translate subMenuX subMenuY $ rectangleWire menuWidth menuHeight, drawShowTranslationButton st, drawLearnContext st]
    ChangeCollectionName -> Pictures [Translate subMenuX subMenuY $ rectangleWire subMenuWidth subMenuHeight,
                                     drawSaveChangeNameButton st, drawButton cancelChangeNameButton Blank,
                                     Translate (subMenuX - subMenuWidth/2 + pad) (subMenuY - pad - buttonHeight/2 + subMenuHeight/2) $ scale 0.2 0.2 $ color black $ text "Enter new collection name:",
                                     Translate (subMenuX - subMenuWidth/2 + pad) (subMenuY - 2*pad - buttonHeight + subMenuHeight/2) $ scale 0.2 0.2 $ color black $ text (newCollectionName st),
                                     Translate (subMenuX - subMenuWidth/2 + pad) (subMenuY - 3*pad - buttonHeight + subMenuHeight/2) $ scale 0.2 0.2 $ color black $ text "______________"]
    _ -> Blank

drawLearnContext :: State -> Picture
drawLearnContext st = case (submode st) of
    Learn 'f' _ -> drawButton finishButton Blank
    Learn 'w' ind -> Pictures [Translate xx yy $ scale 0.25 0.25 $ color black $ text $ word (cards (fromJust (selectedCollection st)) !! ind),
                              drawButton showTranslationButton Blank]
    Learn 't' ind -> Pictures [Translate xx yy $ scale 0.25 0.25 $ color black $ text $ word (cards (fromJust (selectedCollection st)) !! ind), 
                              Translate xx yy1 $ scale 0.25 0.25 $ color black $ text $ translation (cards (fromJust (selectedCollection st)) !! ind),
                              drawButton easyButton Blank, drawButton hardButton Blank, drawButton normalButton Blank, drawButton deleteCardButton Blank, drawButton editCardButton Blank]
    where
        xx = subMenuX + pad - subMenuWidth/2
        yy = subMenuY - pad - buttonHeight/2 + subMenuHeight/2
        yy1 = subMenuY - 2*pad - 3*buttonHeight/2 + subMenuHeight/2

drawCardSettings :: State -> Picture
drawCardSettings st = Pictures [Translate subMenuX subMenuY $ rectangleWire subMenuWidth subMenuHeight,
                                drawButton cancelCardButton Blank, drawSaveCardButton st, drawAddCardWordButton st, drawAddCardTranslationButton st,
                                Translate (subMenuX - subMenuWidth/2 + pad) (subMenuY + pad - 2*buttonHeight + subMenuHeight/2) $ scale 0.2 0.2 $ color black $ text (newCardWord st),
                                Translate (subMenuX - subMenuWidth/2 + pad) (subMenuY - 2*buttonHeight + subMenuHeight/2) $ scale 0.2 0.2 $ color black $ text "______________",
                                Translate (subMenuX - subMenuWidth/2 + pad) (subMenuY + pad - 4*buttonHeight + subMenuHeight/2) $ scale 0.2 0.2 $ color black $ text (newCardTranslation st),
                                Translate (subMenuX - subMenuWidth/2 + pad) (subMenuY - 4*buttonHeight + subMenuHeight/2) $ scale 0.2 0.2 $ color black $ text "______________"]

    
-- collections

drawCollectionList :: State -> Picture
drawCollectionList st = Pictures $ map (drawCollection st) $ dropWhile (\cc -> (center_y (button cc)) > (collectionY - (pad + collectionHeight)) + (cur_y st)) $ collections st

drawCollection :: State -> CardCollection -> Picture
drawCollection st cc = case (button cc) of
    (Button txt x y (Side w h)) -> Translate x (y - (cur_y st)) $ 
        Pictures [rectangleWire w h, Translate (-w/2 + pad/2) (-h/8) $ scale 0.3 0.3 $ color black $ text (name cc),
                  Translate (w/2 - 20) (-h/8) $ scale 0.2 0.2 $ color red $ text $ show (count cc)]
    _ -> Blank


-- buttons 

drawButton :: Button -> Picture -> Picture
drawButton (Button txt x y (Side w h)) pic = Translate x y $ Pictures [rectangleWire w h, rectangleWire (w - 4) (h - 4), drawButtonText (Button txt x y (Side w h)), pic]
drawButton (Button txt x y (Radius r)) pic = Translate x y $ Pictures [Circle r, Circle (r - 2), drawButtonText (Button txt x y (Radius r)), pic]

drawButtonText :: Button -> Picture
drawButtonText (Button txt x y (Side w h)) = Translate (-w/2 + pad/2) (-h/8) $ scale 0.22 0.22 $ color black $ text txt
drawButtonText (Button txt x y (Radius r)) = scale 0.22 0.22 $ color black $ text txt

drawUpButton :: State -> Picture
drawUpButton st
    | (cur_y st) /= 0 = color black $ drawButton upButton $ Pictures [Line [(0, -20), (0, 25)], Polygon [(0, 25), (-15, 10), (0, 15), (15, 10), (0, 25)]]
    | otherwise = Blank

drawSaveChangeNameButton :: State -> Picture
drawSaveChangeNameButton st
    | (newCollectionName st) /= "" = drawButton saveChangeNameButton Blank
    | otherwise = Blank

drawSaveButton :: State -> Picture
drawSaveButton st 
    | (newCollectionName st) /= "" = drawButton saveButton Blank
    | otherwise = Blank

drawSaveCardButton :: State -> Picture
drawSaveCardButton st
    | and [(newCardWord st) /= "", (newCardTranslation st) /= ""] = drawButton saveCardButton Blank
    | otherwise = Blank

drawChangeNameButton :: State -> Picture
drawChangeNameButton st = case (mode st, submode st) of
    (Select, ChangeCollectionName) -> Blank
    (Select, _) -> drawButton changeNameButton Blank
    _ -> Blank

drawLearnButton :: State -> Picture
drawLearnButton st = case (mode st, submode st) of
    (Select, Learn _ _) -> Blank
    (Select, _) -> drawButton learnButton Blank

drawStopButton :: State -> Picture
drawStopButton st = case (mode st, submode st) of
    (Select, Learn _ _) -> drawButton stopButton Blank
    (Select, _) -> Blank

drawAddCardWordButton :: State -> Picture
drawAddCardWordButton st = case (mode st, submode st) of
    (Select, AddCard 'w') -> drawButton addCardWordButton Blank
    (Select, EditCard 'w' _) -> drawButton addCardWordButton Blank
    (Select, AddCard 't') -> color (greyN 0.7) $ drawButton addCardWordButton Blank
    (Select, EditCard 't' _) -> color (greyN 0.7) $ drawButton addCardWordButton Blank
    _ -> Blank

drawAddCardTranslationButton :: State -> Picture
drawAddCardTranslationButton st = case (mode st, submode st) of
    (Select, AddCard 'w') -> color (greyN 0.7) $ drawButton addCardTranslationButton Blank
    (Select, EditCard 'w' _) -> color (greyN 0.7) $ drawButton addCardTranslationButton Blank
    (Select, AddCard 't') -> drawButton addCardTranslationButton Blank
    (Select, EditCard 't' _) -> drawButton addCardTranslationButton Blank
    _ -> Blank

drawShowTranslationButton :: State -> Picture
drawShowTranslationButton st = case (mode st, submode st) of
    (Select, Learn 'w' _) -> drawButton showTranslationButton Blank
    _ -> Blank

