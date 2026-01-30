## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=F-------------------------------------------------------------------
#   #1
# Game = rom.init({game stuff})
# Game$morestuff = {additional game stuff}
# 
#   #2
# RAM = ram.init(Game)
# 	
#   #3
# RAM = ram.run(Game)
# 
#   #4 (in separate session/window)
# inputs.listen()

## ----eval=F-------------------------------------------------------------------
# savestate_1 = RAM
# RAM = ram.run(RAM)
# #play the game a bit via the input session
# ^C
# RAM = savestate_1 #restore the savestate
# RAM = ram.run(RAM) #the game is now back to where it was when savestate_1 was saved

