module Display where


import Graphics.Gloss.Interface.IO.Game
import Graphic
import State
import HandleEvent


displayState :: State -> IO ()
displayState state = playIO (display state) color fps state drawState handleEvent stateUpdate 
    where 
        display state = InWindow "Anki" ((width state), (height state)) (0, 0)
        color = white
        fps = 10

run :: IO ()
run = do
    state <- getState "sets/"
    displayState state
    
    
