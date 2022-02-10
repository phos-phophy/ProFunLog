qsort :: [Int] -> [Int]
qsort [] = []
qsort (a:s) = (qsort left) ++ [a] ++ (qsort right)
    where
        left = filter (< a) s
        right = filter (>= a) s
    
    
toInt :: String -> [Int]
toInt inp = map read (words inp)


main :: IO ()
main =  do
    putStrLn "Enter integer array"
    x <- getLine
    print(qsort (toInt x))
