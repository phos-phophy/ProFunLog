module State where

import System.Directory
import Card
import Button
import Utils
import Data.List
import Data.Maybe

data Mode = None | AddCardCollection | Select
data SubMode = None1 | AddCard Char | Learn Char Int | ChangeCollectionName | EditCard Char Int

data State = State
    { path_to_cols :: String
    , collections :: [CardCollection]
    , erase :: Bool
    , mode :: Mode
    , submode :: SubMode
    , newCollectionName :: String
    , newCardWord :: String
    , newCardTranslation :: String
    , selectedCollection :: Maybe CardCollection  
    , width :: Int
    , height :: Int
    , cur_y :: Float
    }

stateUpdate :: Float -> State -> IO State
stateUpdate _ st = case (erase st, mode st, submode st) of
    (True, AddCardCollection, _) -> return st {newCollectionName = deleteLast (newCollectionName st)}
    (True, Select, ChangeCollectionName) -> return st {newCollectionName = deleteLast (newCollectionName st)}
    (True, Select, AddCard 'w') -> return st {newCardWord = deleteLast (newCardWord st)}
    (True, Select, AddCard 't') -> return st {newCardTranslation = deleteLast (newCardTranslation st)}
    (True, Select, EditCard 'w' _) -> return st {newCardWord = deleteLast (newCardWord st)}
    (True, Select, EditCard 't' _) -> return st {newCardTranslation = deleteLast (newCardTranslation st)}
    _ -> return st


getState :: String -> IO State
getState path = do
    files_ <- listDirectory path
    let files = map (\x -> path ++ x) files_
    cols <- loadAllCollections [] 1 files
    return $ State {path_to_cols = path, collections = cols, mode = None, submode = None1, newCollectionName = "", 
                    selectedCollection = Nothing, width = 1000, height = 1000, cur_y = 0,
                    newCardWord = "", newCardTranslation = "", erase = False}

resetState :: State -> State
resetState st = (resetSubState st) {mode = None, selectedCollection = Nothing}

resetSubState :: State -> State
resetSubState st = st {submode = None1, newCardTranslation = "", newCardWord = "", erase = False, newCollectionName = ""}

getSelectedIndex :: State -> Maybe (CardCollection, Int)
getSelectedIndex st = case (selectedCollection st) of
    Nothing -> Nothing
    Just cc -> Just (cc, fromJust $ elemIndex cc (collections st))
