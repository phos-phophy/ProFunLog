module HandleEvent where

import Graphics.Gloss.Interface.IO.Game
import System.Directory
import Card
import State
import Utils
import Button
import Data.List
import Data.Maybe
import Data.Time.Clock.POSIX


handleEvent :: Event -> State -> IO State
handleEvent (EventKey (Char c) Down _ _) st = case (mode st, submode st) of
    (AddCardCollection, _) -> return st {newCollectionName = (newCollectionName st) ++ [c]}
    (Select, AddCard 'w') -> return st {newCardWord = (newCardWord st) ++ [c]}
    (Select, AddCard 't') -> return st {newCardTranslation = (newCardTranslation st) ++ [c]}
    _ -> return st
handleEvent (EventKey (SpecialKey KeySpace) Down _ _ ) st = case (mode st, submode st) of
    (AddCardCollection, _) -> return st {newCollectionName = (newCollectionName st) ++ [' ']}
    (Select, AddCard 'w') -> return st {newCardWord = (newCardWord st) ++ [' ']}
    (Select, AddCard 't') -> return st {newCardTranslation = (newCardTranslation st) ++ [' ']}
    _ -> return st
handleEvent (EventKey (SpecialKey KeyDelete) Down _ _) st = return $ st {erase = True}
handleEvent (EventKey (SpecialKey KeyDelete) Up _ _) st = return $ st {erase = False}
handleEvent (EventKey (MouseButton WheelDown) _ _ _) st = return st {cur_y = (cur_y st) - 15}
handleEvent (EventKey (MouseButton WheelUp) _ _ _) st = return st {cur_y = min ((cur_y st) + 15) 0}
handleEvent (EventKey (MouseButton LeftButton) Down _ (x, y)) st
    | isUpButton x y = return st {cur_y = 0}
    | isAddButton x y = return $ (resetState st) {mode = AddCardCollection}
    | isSaveButton st x y = saveCollection st
    | isSaveCardButton st x y = saveCard st
    | isCancelButton st x y = return $ resetState st
    | isCancelCardButton st x y = return $ resetSubState st
    | isDeleteButton st x y = deleteCollection st
    | isAddCardButton st x y = return $ st {submode = AddCard 'w'}
    | isAddCardWordButton st x y = return $ st {submode = AddCard 'w'}
    | isAddCardTranslationButton st x y = return $ st {submode = AddCard 't'}
    | isLearnButton st x y = return $ (resetSubState st) {submode = Learn 'w' 0}
    | isStopButton st x y = return $ resetSubState st
    | isShowButton st x y = return $ st {submode = Learn 't' ind}
    | otherwise = case (isCollection st x y) of
        Just col -> return $ (resetState st) {mode = Select, selectedCollection = Just col}
        Nothing -> return st
    where
        (Learn _ ind) = submode st
handleEvent _ st = return st


-- Action functions

saveCollection :: State -> IO State
saveCollection st = do
    time <- getPOSIXTime
    let newName = show $ round time
    let path = (path_to_cols st) ++ newName  ++ ".txt"
    writeFile path ((newCollectionName st) ++ "\n")
    cc <- loadCollection (fromIntegral ((length (collections st)) + 1)) path
    return $ resetState $ st {collections = (collections st) ++ [cc]}

deleteCollection :: State -> IO State
deleteCollection st = do
    removeFile $ path $ fromJust $ selectedCollection st
    let index = fromJust $ elemIndex (fromJust (selectedCollection st)) cc
    let new_cc = (take index cc) ++ (drop (index + 1) cc)
    return $ st {collections = updateCollectionPositions new_cc}
    where
        cc = collections st

saveCard :: State -> IO State
saveCard st = do
    time <- getPOSIXTime
    let card = Card (newCardWord st) (newCardTranslation st) (-1) (round time)
    appendFile (path (fromJust (selectedCollection st))) $ cardToString card
    cc <- reloadCollection $ fromJust $ selectedCollection st
    let index = fromJust $ elemIndex cc (collections st)
    return $ resetSubState $ st {selectedCollection = Just cc, 
        collections = (take index (collections st)) ++ [cc] ++ (drop (index + 1) (collections st))}

activateLearnSubMode :: State -> IO State
activateLearnSubMode st = do
    curTime <- getPOSIXTime
    return $ activate st $ findNextCardToLearn (fromJust (selectedCollection st)) 0 (round curTime)

activate :: State -> Int -> State
activate st ind 
    | ind == -1 = (resetSubState st) {submode = Learn 'f' 0}
    | otherwise = (resetSubState st) {submode = Learn 'w' ind}
    

-- Check functions

isUpButton :: Float -> Float -> Bool
isUpButton x y = isButton upButton x y 0

isAddButton :: Float -> Float -> Bool
isAddButton x y = isButton addButton x y 0

isAddCardButton :: State -> Float -> Float -> Bool
isAddCardButton st x y = case (mode st) of
    Select -> isButton addCardButton x y 0
    _ -> False

isCancelButton :: State -> Float -> Float -> Bool
isCancelButton st x y = case (mode st) of
    AddCardCollection -> isButton cancelButton x y 0
    Select -> isButton cancelButton x y 0
    _ -> False

isCancelCardButton :: State -> Float -> Float -> Bool
isCancelCardButton st x y = case (submode st) of
    AddCard c -> isButton cancelCardButton x y 0
    _ -> False

isDeleteButton :: State -> Float -> Float -> Bool
isDeleteButton st x y = case (mode st) of
    Select -> isButton deleteButton x y 0
    _ -> False

isSaveButton :: State -> Float -> Float -> Bool
isSaveButton st x y = case (mode st) of
    AddCardCollection -> and [isButton saveButton x y 0, (newCollectionName st) /= ""]
    _ -> False

isSaveCardButton :: State -> Float -> Float -> Bool
isSaveCardButton st x y = case (submode st) of
    AddCard c -> and [isButton saveCardButton x y 0, (newCardWord st) /= "", (newCardTranslation st) /= ""]
    _ -> False

isAddCardWordButton :: State -> Float -> Float -> Bool
isAddCardWordButton st x y = case (mode st, submode st) of
    (Select, AddCard _) -> isButton addCardWordButton x y 0
    _ -> False

isAddCardTranslationButton :: State -> Float -> Float -> Bool
isAddCardTranslationButton st x y = case (mode st, submode st) of
    (Select, AddCard _) -> isButton addCardTranslationButton x y 0
    _ -> False

isLearnButton :: State -> Float -> Float -> Bool
isLearnButton st x y = case (mode st, submode st) of
    (Select, Learn _ _) -> False
    (Select, _) -> isButton learnButton x y 0
    _ -> False

isStopButton :: State -> Float -> Float -> Bool
isStopButton st x y = case (mode st, submode st) of
    (Select, Learn _ _) -> isButton stopButton x y 0
    _ -> False

isShowButton :: State -> Float -> Float -> Bool
isShowButton st x y = case (mode st, submode st) of 
    (Select, Learn 'w' ind) -> isButton showTranslationButton x y 0
    _ -> False

isCollection :: State -> Float -> Float -> Maybe CardCollection
isCollection st x y = case (dropWhile (\cc -> not (isButton (button cc) x y (cur_y st))) $ dropWhile (\cc -> (center_y (button cc)) > (collectionY - (pad + collectionHeight)) + (cur_y st)) $ collections st) of
    [] -> Nothing
    (x:xs) -> Just x

