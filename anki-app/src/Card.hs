module Card where

import System.Directory
import Utils
import Button
import Data.Maybe
import Data.List


data Card = Card
    { word :: String
    , translation :: String
    , lastLearningTime :: Int
    , rating :: Int
    }

cardToString :: Card -> String
cardToString (Card w t llt r) = w ++ "\t" ++ t ++ "\t" ++ (show llt) ++ "\t" ++ (show r) ++"\n"

stringToCard :: String -> Card
stringToCard str = Card (ws !! 0) (ws !! 1) llt r
    where 
        ws = (wordsWhen (=='\t') str)
        llt = read (ws !! 2) :: Int
        r = read (ws !! 3) :: Int

isNeedToLearn :: Card -> Int -> Bool
isNeedToLearn (Card w t llt r) curTime = (curTime - llt) >= (r * 2 + 1) * 86400


data CardCollection = CardCollection
    { name :: String
    , path :: String
    , count :: Int  -- num of cards
    , cards :: [Card]
    , button :: Button
    }

instance Eq CardCollection where
    CardCollection _ path1 _ _ _ == CardCollection _ path2 _ _ _ = path1 == path2

findNextCardToLearn :: CardCollection -> Int -> Int -> Int
findNextCardToLearn cc@(CardCollection _ _ count cards _) ind curTime
    | ind == count = -1
    | isNeedToLearn (cards !! ind) curTime = ind
    | otherwise = findNextCardToLearn cc (ind + 1) curTime

loadAllCollections :: [CardCollection] -> Float -> [String] -> IO [CardCollection]
loadAllCollections ans _ [] = return ans
loadAllCollections ans ind paths = do
    cc <- loadCollection ind $ head paths
    loadAllCollections (ans ++ [cc]) (ind + 1) $ tail paths 

loadCollection :: Float -> String -> IO CardCollection
loadCollection ind path = do
    (name, cards) <- getCollectionInfo path
    return $ CardCollection name path (length cards) cards (collectionButton ind)

reloadCollection :: CardCollection -> IO CardCollection
reloadCollection cc = do
    (name, cards) <- getCollectionInfo $ path cc
    return cc {cards = cards, count = length cards}

updateCollectionPositions :: [CardCollection] -> [CardCollection]
updateCollectionPositions cc = zipWith (\c ind -> c {button = collectionButton ind}) cc indx where indx = [1..] :: [Float]

getCollectionInfo :: String -> IO (String, [Card])
getCollectionInfo path = do
    ll <- readFile path
    let tmp = lines $ ll 
    let ans | (head tmp) /= "" = (head tmp, map stringToCard $ tail tmp)
            | otherwise = ("", [])  -- get rid of lazy
    return ans
