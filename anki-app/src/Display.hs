module Display where

import Graphics.Gloss.Interface.Pure.Game
import Card
import Graphic
import State


handleEvent :: Event -> State -> State
handleEvent (EventKey (MouseButton WheelDown) _ _ _) st = st {cur_y = (cur_y st) - 15}
handleEvent (EventKey (MouseButton WheelUp) _ _ _) st = st {cur_y = min ((cur_y st) + 15) 0}
handleEvent _ m = m

stateUpdate :: Float -> State -> State
stateUpdate _ m = m

displayState :: State -> IO()
displayState state = play (display state) color fps state drawState handleEvent stateUpdate 
    where 
        display state = InWindow "Anki" ((width state), (height state)) (0, 0)
        color = white
        fps = 1


run :: IO()
run = do
    state <- getState "sets/"
    displayState state
    
