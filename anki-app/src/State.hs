module State where

import System.Directory
import Card


data State = State
    { path_to_cols :: String
    , collections :: [CardCollection]
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
    cols <- loadCardCollections [] files
    return State {path_to_cols = path, collections = cols, selectedCollection = Nothing, selectedCard = Nothing, width = 1000, height = 1000, cur_y = 0}


