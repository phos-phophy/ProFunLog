module Menu where

import System.Directory

data Menu = Menu
    { paths :: [String]
    , selected :: Maybe String
    , selectedCard :: Maybe Card 
    , width :: Int
    , height :: Int
    }

getMenu :: String -> IO Menu
getMenu path = do
    ps <- listDirectory path
    return Menu{paths = ps, selected = Nothing, selectedCard = Nothing, width = 800, height = 800}

selectSet :: Menu -> String -> Menu
selectSet m f = m{selected = f}

chooseSet :: Menu -> Int -> String
chooseSet m i = (paths m) !! i
