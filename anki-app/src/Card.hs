module Card where


data Card = Card
    { word :: String
    , translate :: String
    }

createCard :: String -> String -> Card
createCard word translate = Card word translate

cardToString :: Card -> String
cardToString card = (word card) ++ "\t" ++ (translate card) ++ "\n"

stringToCard :: String -> Card
stringToCard str = Card (ws !! 0) (ws !! 1) where ws = (wordsWhen (=='\t') str)


data CardSet = CardSet 
    { path :: String
    , cards :: [Card]
    }

loadCardSet :: CardSet -> IO CardSet
loadCardSet cs = do
    strs <- readFile (path cs)
    return cs{cards = map stringToCard (lines strs)}

createCardSet :: String -> CardSet
createCardSet path = CardSet path []

addCardToSet :: CardSet -> Card -> IO CardSet
addCardToSet cs card = do
    appendFile (path cs) (cardToString card)
    return CardSet (path cs) ((cards cs) ++ [card])

removeCardFromSet :: CardSet -> Card -> IO CardSet

wordsWhen :: (String -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'
