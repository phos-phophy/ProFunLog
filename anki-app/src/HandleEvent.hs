module HandleEvent where

import Graphics.Gloss.Interface.IO.Game
import System.Directory
import Card
import State
import Utils
import Button
import Data.List
import Data.Maybe


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
    | isSaveButton st x y = saveNewCollection st
    | isSaveCardButton st x y = saveNewCard st
    | isCancelButton st x y = return $ resetState st
    | isCancelCardButton st x y = return $ resetSubState st
    | isDeleteButton st x y = deleteCollection st
    | isAddCardButton st x y = return $ st {submode = AddCard 'w'}
    | isAddCardWordButton st x y = return $ st {submode = AddCard 'w'}
    | isAddCardTranslationButton st x y = return $ st {submode = AddCard 't'}
    | isLearnButton st x y = activateLearnSubMode st
    | isStopButton st x y = return $ resetSubState st
    | isShowButton st x y = return $ st {submode = Learn 't' ind}
    | isEasyButton st x y = nextLearn st 'e'
    | isNormalButton st x y = nextLearn st 'n'
    | isHardButton st x y = nextLearn st 'h'
    | otherwise = case (isCollection st x y) of
        Just col -> return $ (resetState st) {mode = Select, selectedCollection = Just col}
        Nothing -> return st
    where
        (Learn _ ind) = submode st
handleEvent _ st = return st


-- Action functions

saveNewCollection :: State -> IO State
saveNewCollection st = do
    time <- getTime
    let path = (path_to_cols st) ++ (show time) ++ ".txt"
    cc <- writeNewCollectionToFile (fromIntegral (length (collections st)) + 1) path (newCollectionName st)
    return $ resetState $ st {collections = (collections st) ++ [cc]}

deleteCollection :: State -> IO State
deleteCollection st = do
    removeFile $ path $ fromJust $ selectedCollection st
    return $ resetState $ st {collections = updateCollectionPositions (dropByIndex cc index)}
    where
        cc = collections st
        index = fromJust $ elemIndex (fromJust (selectedCollection st)) cc

saveNewCard :: State -> IO State
saveNewCard st = do
    time <- getTime
    cc <- addCardToCollection (fromJust (selectedCollection st)) $ Card (newCardWord st) (newCardTranslation st) time (-1)
    let index = fromJust $ elemIndex cc (collections st)
    return $ resetSubState $ st {selectedCollection = Just cc, collections = changeByIndex (collections st) index cc}

activateLearnSubMode :: State -> IO State
activateLearnSubMode st = do
    curTime <- getTime
    return $ nextOrEndLearn st $ findNextCardToLearn (fromJust (selectedCollection st)) 0 curTime

nextOrEndLearn :: State -> Int -> State
nextOrEndLearn st ind 
    | ind == -1 = (resetSubState st) {submode = Learn 'f' 0}
    | otherwise = (resetSubState st) {submode = Learn 'w' ind}

nextLearn :: State -> Char -> IO State
nextLearn st how = do
    time <- getTime
    let new_cc = cc {cards = changeByIndex (cards cc) ind (changeRating ((cards cc) !! ind) time how)}
    writeCollectionToFile new_cc
    return $ nextOrEndLearn (st {collections = changeByIndex (collections st) index new_cc, selectedCollection = Just new_cc}) $ findNextCardToLearn new_cc (ind + 1) time
    where
        Learn 't' ind = submode st
        cc = fromJust $ selectedCollection st
        index = fromJust $ elemIndex cc (collections st)

changeRating :: Card -> Int -> Char -> Card
changeRating card time how = case how of
    'n' -> card {lastLearningTime = time}
    'h' -> card {lastLearningTime = time, rating = -1}
    'e' -> card {lastLearningTime = time, rating = (rating card) + 1}

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

isEasyButton :: State -> Float -> Float -> Bool
isEasyButton st x y = case (mode st, submode st) of
    (Select, Learn 't' ind) -> isButton easyButton x y 0
    _ -> False

isNormalButton :: State -> Float -> Float -> Bool
isNormalButton st x y = case (mode st, submode st) of
    (Select, Learn 't' ind) -> isButton normalButton x y 0
    _ -> False

isHardButton :: State -> Float -> Float -> Bool
isHardButton st x y = case (mode st, submode st) of
    (Select, Learn 't' ind) -> isButton hardButton x y 0
    _ -> False

isCollection :: State -> Float -> Float -> Maybe CardCollection
isCollection st x y = case (dropWhile (\cc -> not (isButton (button cc) x y (cur_y st))) $ dropWhile (\cc -> (center_y (button cc)) > (collectionY - (pad + collectionHeight)) + (cur_y st)) $ collections st) of
    [] -> Nothing
    (x:xs) -> Just x

