module Card where

import System.Directory


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
    }

loadCardCollections :: [CardCollection] -> [String] -> IO [CardCollection]
loadCardCollections ans [] = return ans
loadCardCollections ans paths = do
    cc <- load_ $ head paths
    loadCardCollections (ans ++ [cc]) $ tail paths 
    where
        load_ :: String -> IO CardCollection
        load_ path = do
            file <- readFile path
            let ll = lines file
            let cards = map stringToCard $ (tail ll)
            return $ CardCollection (head ll) path (length cards) cards            

createNewCardCollection :: String -> String -> CardCollection
createNewCardCollection name path = CardCollection name path 0 []

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
