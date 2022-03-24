module Card where

import System.Directory


collectionHeight :: Float
collectionHeight = 70

collectionWidth :: Float
collectionWidth = 400

init_x :: Float
init_x = (-collectionWidth / 2) - 20

init_y :: Float
init_y = 400


data Card = Card
    { word :: String
    , translate :: String
    }

cardToString :: Card -> String
cardToString card = (word card) ++ "\t" ++ (translate card) ++ "\n"

stringToCard :: String -> Card
stringToCard str = Card (ws !! 0) (ws !! 1) where ws = (wordsWhen (=='\t') str)


data CardCollection = CardCollection
    { name :: String
    , path :: String
    , count :: Int  -- num of cards
    , cards :: [Card]
    , x_pos :: Float
    , y_pos :: Float
    }

loadCardCollections :: [CardCollection] -> Float -> [String] -> IO [CardCollection]
loadCardCollections ans ind [] = return ans
loadCardCollections ans ind paths = do
    cc <- load_ ind $ head paths
    loadCardCollections (ans ++ [cc]) (ind + 1) $ tail paths 

load_ :: Float -> String -> IO CardCollection
load_ ind path = do
    file <- readFile path
    let ll = lines file
    let cards = map stringToCard $ (tail ll)
    return $ CardCollection (head ll) path (length cards) cards init_x (init_y - ind * 80)

--createNewCardCollection :: State -> String -> String -> CardCollection
--createNewCardCollection st name path = CardCollection name path 0 []

addCardToCollection :: CardCollection -> Card -> IO CardCollection
addCardToCollection cc card = do
    appendFile (path cc) (cardToString card)
    return cc {count = (count cc) + 1, cards = (cards cc) ++ [card]}

removeCardCollection :: CardCollection -> IO ()
removeCardCollection cc = removeFile (path cc)

removeCardFromCollection :: CardCollection -> Card -> IO CardCollection
removeCardFromCollection cs c = return cs

wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'
