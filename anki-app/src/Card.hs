module Card where

import System.Directory()
import Utils
import Button
import Data.Maybe()
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
isNeedToLearn (Card _ _ llt r) curTime = (curTime - llt) >= (r * 2 + 1) * 86400


data CardCollection = CardCollection
    { name :: String
    , path :: String
    , count :: Int  -- num of cards
    , cards :: [Card]
    , button :: Button
    }

instance Eq CardCollection where
    CardCollection _ path1 _ _ _ == CardCollection _ path2 _ _ _ = path1 == path2

writeCollectionToFile :: CardCollection -> IO ()
writeCollectionToFile cc = do
    let content = (name cc) ++ "\n" ++ (intercalate "" (map cardToString (cards cc)))
    writeFile (path cc) content

writeNewCollectionToFile :: Float -> String -> String -> IO CardCollection
writeNewCollectionToFile ind path0 name0 = do
    writeFile path0 (name0 ++ "\n")
    loadCollection ind path0

loadCollection :: Float -> String -> IO CardCollection
loadCollection ind path0 = do
    (name0, cards0) <- getCollectionInfo path0
    return $ CardCollection name0 path0 (length cards0) cards0 (collectionButton ind)

reloadCollection :: CardCollection -> IO CardCollection
reloadCollection cc = do
    (_, cards0) <- getCollectionInfo $ path cc
    return cc {cards = cards0, count = length cards0}

loadAllCollections :: [CardCollection] -> Float -> [String] -> IO [CardCollection]
loadAllCollections ans _ [] = return ans
loadAllCollections ans ind paths = do
    cc <- loadCollection ind $ head paths
    loadAllCollections (ans ++ [cc]) (ind + 1) $ tail paths 

addCardToCollection :: CardCollection -> Card -> IO CardCollection
addCardToCollection cc card = do
    appendFile (path cc) $ cardToString card
    return cc {cards = (cards cc) ++ [card], count = (count cc) + 1}

updateCollectionPositions :: [CardCollection] -> [CardCollection]
updateCollectionPositions cc = zipWith (\c ind -> c {button = collectionButton ind}) cc indx where indx = [1..] :: [Float]

findNextCardToLearn :: CardCollection -> Int -> Int -> Int
findNextCardToLearn cc@(CardCollection _ _ count0 cards0 _) ind curTime
    | ind >= count0 = -1
    | isNeedToLearn (cards0 !! ind) curTime = ind
    | otherwise = findNextCardToLearn cc (ind + 1) curTime

getCollectionInfo :: String -> IO (String, [Card])
getCollectionInfo path0 = do
    ll <- readFile path0
    let tmp = lines $ ll
    let ans | (head tmp) /= "" = (head tmp, map stringToCard $ tail tmp)
            | otherwise = ("", [])  -- get rid of lazy
    return ans
