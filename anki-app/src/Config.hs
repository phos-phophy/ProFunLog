module Config where


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

