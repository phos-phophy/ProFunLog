module Display where


import Graphics.Gloss.Interface.IO.Game
import Graphic
import State
import HandleEvent


displayState :: State -> IO ()
displayState state = playIO (display state) color0 fps state drawState handleEvent stateUpdate 
    where 
        display state0 = InWindow "Anki" ((width state0), (height state0)) (0, 0)
        color0 = white
        fps = 10

run :: IO ()
run = do
    state <- getState "sets/"
    displayState state
    
    
