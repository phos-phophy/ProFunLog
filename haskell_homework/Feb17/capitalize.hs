import Data.Char 


capitalize :: [String] -> [String]
capitalize arr = map cap arr

    
cap :: String -> String
cap [] = []
cap (a:s) = toUpper a : s


main :: IO ()
main =  do
    putStrLn "Enter sentence"
    x <- getLine
    print(capitalize (words x))
