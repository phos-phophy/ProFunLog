module Display where

import System.Directory
import Graphics.Gloss.Interface.IO.Game
import Card
import Graphic
import State


handleEvent :: Event -> State -> IO State
handleEvent (EventKey (Char c) Down _ _) st = case (mode st) of
    AddCardCollection -> return st {newCollectionName = (newCollectionName st) ++ [c]}
    _ -> return st
handleEvent (EventKey (SpecialKey KeyDelete) Down _ _) st = case (mode st) of
    AddCardCollection -> return st {newCollectionName = deleteLast (newCollectionName st)}
    _ -> return st
handleEvent (EventKey (MouseButton WheelDown) _ _ _) st = return st {cur_y = (cur_y st) - 15}
handleEvent (EventKey (MouseButton WheelUp) _ _ _) st = return st {cur_y = min ((cur_y st) + 15) 0}
handleEvent (EventKey (MouseButton LeftButton) Down _ (x, y)) st
    | isUpButton x y = return st {cur_y = 0}
    | isAddButton x y = return st {mode = AddCardCollection}
    | isSaveButton st x y = do
        let path = (path_to_cols st) ++ (show (1 + (length (collections st)))) ++ ".txt"
        writeFile path ((newCollectionName st) ++ "\n")
        cc <- load_ (fromIntegral ((length (collections st)) + 1)) path
        return st {collections = (collections st) ++ [cc], mode = None, newCollectionName = ""}
    | otherwise = return st
handleEvent _ st = return st

isUpButton :: Float -> Float -> Bool
isUpButton x y
    | (x - upButton_x) ^ 2 + (y - upButton_y) ^ 2 > upButton_r ^ 2 = False
    | otherwise = True

isAddButton :: Float -> Float -> Bool
isAddButton x y
    | x > init_x + w || x < init_x - w = False
    | y > init_y + h || y < init_y - h = False
    | otherwise = True
    where
        w = collectionWidth / 2
        h = collectionHeight / 2

isSaveButton :: State -> Float -> Float -> Bool
isSaveButton st x y = case (mode st) of
    AddCardCollection -> check_ (newCollectionName st) x y
    _ -> False
    where
        check_ :: String -> Float -> Float -> Bool
        check_ name x y
            | name == "" = False
            | x > saveButton_x + saveButton_w / 2 || x < saveButton_x - saveButton_w / 2 = False
            | y > saveButton_y + saveButton_h / 2 || y < saveButton_y - saveButton_h / 2 = False
            | otherwise = True

deleteLast :: [a] -> [a]
deleteLast [] = []
deleteLast l = init l

stateUpdate :: Float -> State -> IO State
stateUpdate _ st = return st

displayState :: State -> IO ()
displayState state = playIO (display state) color fps state drawState handleEvent stateUpdate 
    where 
        display state = InWindow "Anki" ((width state), (height state)) (0, 0)
        color = white
        fps = 1

run :: IO ()
run = do
    state <- getState "sets/"
    displayState state
    
    
