module Button where

-- Left menu
buttonWidth :: Float
buttonWidth = 140

buttonHeight :: Float
buttonHeight = 50

collectionHeight :: Float
collectionHeight = 70

collectionWidth :: Float
collectionWidth = 400

collectionX :: Float
collectionX = -collectionWidth/2 - 2*pad

collectionY :: Float
collectionY = 400

-- Right menu
menuWidth :: Float
menuWidth = 400

menuHeight :: Float
menuHeight = 300

menuX :: Float
menuX = menuWidth/2 + 2*pad

menuY :: Float
menuY = collectionY - menuHeight/2 + collectionHeight/2

-- Right submenu
subMenuWidth :: Float
subMenuWidth = 400

subMenuHeight :: Float
subMenuHeight = 300

subMenuX :: Float
subMenuX = subMenuWidth/2 + 2*pad

subMenuY :: Float
subMenuY = menuY - pad - menuHeight/2 - subMenuHeight/2

pad :: Float
pad = 10


data Size = Radius Float | Side Float Float -- radius | width height

data Button = Button 
    { msg :: String
    , center_x :: Float
    , center_y :: Float
    , size :: Size
    }


-- init all buttons:

-- 1) Left menu
addButton :: Button
addButton = Button "+Add new card collection" collectionX collectionY (Side collectionWidth collectionHeight)

upButton :: Button
upButton = Button "" (collectionX - collectionWidth/2 - pad - r) (collectionY - pad - collectionHeight) (Radius r) where r = 30

-- 2) Right menu
addCardButton :: Button
addCardButton = Button "New card" (menuX + pad - menuWidth/2 + w/2) (menuY + pad - menuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

saveButton :: Button
saveButton = Button "Save" (menuX + pad - menuWidth/2 + w/2) (menuY + pad - menuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

cancelButton :: Button
cancelButton = Button "Cancel" (menuX - pad - w/2 + menuWidth/2) (menuY + pad - menuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

deleteButton :: Button
deleteButton = Button "Delete" (menuX - pad - w/2 + menuWidth/2) (menuY + menuHeight/2 - pad - h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

stopButton :: Button
stopButton = Button "Stop" (menuX + pad - menuWidth/2 + w/2) (menuY + 2*pad - menuHeight/2 + 3*h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

learnButton :: Button
learnButton = Button "Learn" (menuX + pad - menuWidth/2 + w/2) (menuY + 2*pad - menuHeight/2 + 3*h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

-- 3) Right submenu
saveCardButton :: Button
saveCardButton = Button "Save" (subMenuX + pad - subMenuWidth/2 + w/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

cancelCardButton :: Button
cancelCardButton = Button "Cancel" (subMenuX - pad - w/2 + subMenuWidth/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

addCardWordButton :: Button
addCardWordButton = Button "Word" (subMenuX + pad - subMenuWidth/2 + w/2) (subMenuY - pad + subMenuHeight/2 - h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

addCardTranslationButton :: Button
addCardTranslationButton = Button "Translation" (subMenuX + pad - subMenuWidth/2 + w/2) (subMenuY - pad + subMenuHeight/2 - 5*h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

showTranslationButton :: Button
showTranslationButton = Button "Show" (subMenuX) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

easyButton :: Button
easyButton = Button "Easy" (subMenuX + pad - subMenuWidth/2 + w/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

hardButton :: Button
hardButton = Button "Hard" (subMenuX - pad + subMenuWidth/2 - w/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

collectionButton :: Float -> Button
collectionButton ind = Button "" collectionX (collectionY - ind * (pad + collectionHeight)) (Side collectionWidth collectionHeight)

-- check function
isButton :: Button -> Float -> Float -> Float -> Bool
isButton (Button _ xb yb (Radius r)) x y y_bias = (xb - x) ^ 2 + (yb - (y + y_bias)) ^ 2 <= r ^ 2
isButton (Button _ xb yb (Side w h)) x y y_bias = and [x >= (xb - w/2), x <= (xb + w/2), (y + y_bias) <= (yb + h/2), (y + y_bias) >= (yb - h/2)]
