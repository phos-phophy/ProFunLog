module Utils where

import Data.Time.Clock.POSIX


getTime :: IO Int
getTime = do
    time <- getPOSIXTime
    return $ round time


dropByIndex :: [a] -> Int -> [a]
dropByIndex l ind = (take ind l) ++ (drop (ind + 1) l)


changeByIndex :: [a] -> Int -> a -> [a]
changeByIndex l ind x = (take ind l) ++ [x] ++ (drop (ind + 1) l)


deleteLast :: [a] -> [a]
deleteLast [] = []
deleteLast l = init l


wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'
