module Utils where


deleteLast :: [a] -> [a]
deleteLast [] = []
deleteLast l = init l


wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'
