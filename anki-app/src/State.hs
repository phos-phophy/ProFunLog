module State where

import System.Directory
import Card


data Mode = None | AddCardCollection | Learn


data State = State
    { path_to_cols :: String
    , collections :: [CardCollection]
    , mode :: Mode
    , newCollectionName :: String
    , selectedCollection :: Maybe CardCollection 
    , selectedCard :: Maybe Card 
    , width :: Int
    , height :: Int
    , cur_y :: Float
    }

getState :: String -> IO State
getState path = do
    files_ <- listDirectory path
    let files = map (\x -> path ++ x) files_
    cols <- loadCardCollections [] 1 files
    return State {path_to_cols = path, collections = cols, mode = None, newCollectionName = "", selectedCollection = Nothing, selectedCard = Nothing, width = 1000, height = 1000, cur_y = 0}

