module Button where

import Config


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
deleteButton = Button "Delete" (menuX - pad - w/2 + menuWidth/2) (menuY + menuHeight/2 - 2*pad -3*h/2) (Side w h) where (w, h) = (2*buttonWidth/3, buttonHeight)

stopButton :: Button
stopButton = Button "Stop" (menuX + pad - menuWidth/2 + w/2) (menuY + 2*pad - menuHeight/2 + 3*h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

learnButton :: Button
learnButton = Button "Learn" (menuX + pad - menuWidth/2 + w/2) (menuY + 2*pad - menuHeight/2 + 3*h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

changeNameButton :: Button
changeNameButton = Button "Change name" (menuX + pad - menuWidth/2 + w/2) (menuY + 3*pad - menuHeight/2 + 5*h/2) (Side w h) where (w, h) = (3*buttonWidth/2, buttonHeight)

-- 3) Right submenu
saveChangeNameButton :: Button
saveChangeNameButton = Button "Save" (subMenuX + pad - subMenuWidth/2 + w/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

cancelChangeNameButton :: Button
cancelChangeNameButton = Button "Cancel" (subMenuX - pad - w/2 + subMenuWidth/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = (buttonWidth, buttonHeight)

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
easyButton = Button "Easy" (subMenuX + pad - subMenuWidth/2 + w/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = ((subMenuWidth - 4*pad) / 3, buttonHeight)

normalButton :: Button
normalButton = Button "Normal" subMenuX (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = ((subMenuWidth - 4*pad) / 3, buttonHeight)

hardButton :: Button
hardButton = Button "Hard" (subMenuX - pad + subMenuWidth/2 - w/2) (subMenuY + pad - subMenuHeight/2 + h/2) (Side w h) where (w, h) = ((subMenuWidth - 4*pad) / 3, buttonHeight)

finishButton :: Button
finishButton = Button "Finish!" subMenuX subMenuY (Side w h) where (w, h) = (buttonWidth, buttonHeight)

deleteCardButton :: Button
deleteCardButton = Button "Delete" (subMenuX + subMenuWidth/2 - pad - w/2)  (subMenuY - subMenuHeight/2 + 5*h/2 + 3*pad) (Side w h) where (w, h) = (2*buttonWidth/3, buttonHeight)

editCardButton :: Button
editCardButton = Button "Edit" (subMenuX - subMenuWidth/2 + pad + w/2) (subMenuY - subMenuHeight/2 + 3*h/2 + 2*pad) (Side w h) where (w, h) = (buttonWidth/2, buttonHeight)

-- 4) Collection
collectionButton :: Float -> Button
collectionButton ind = Button "" collectionX (collectionY - ind * (pad + collectionHeight)) (Side collectionWidth collectionHeight)

-- check function
isButton :: Button -> Float -> Float -> Float -> Bool
isButton (Button _ xb yb (Radius r)) x y y_bias = (xb - x) ^ st + (yb - (y + y_bias)) ^ st <= r ^ st where st = 2 :: Integer
isButton (Button _ xb yb (Side w h)) x y y_bias = and [x >= (xb - w/2), x <= (xb + w/2), (y + y_bias) <= (yb + h/2), (y + y_bias) >= (yb - h/2)]
