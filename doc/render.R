## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----include=FALSE------------------------------------------------------------

devtools::load_all(".")

## ----eval=F-------------------------------------------------------------------
# cat('
#   []  []
#   []  []
# 
# []      []
#   [][][]
# ')

## -----------------------------------------------------------------------------
render.matrix = function(M, palette = c('  ', '[]', '  ')){
  #we assume the bitmap to be positive integers
  
  #attach a line of -1 values on the rightmost column to turn into newlines
  M = rbind(t(M),-1) #transpose to match the orientation of print(M)
  
  #add two to make all values work as vector indices
  M = M + 2
  
  #convert matrix to vector of strings using its values as indices
  str = c('\n',palette)[M]
  
	cat(str, sep='') #collapse vector and print
}

render.matrix(matrix(c(0,0,1,0,0,0,0,1,1,1,0,1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,0), ncol = 7))

## -----------------------------------------------------------------------------
#A sprite is anything that can be printed by render.matrix():
sprite = matrix(c(0,0,1,0,0,0,0,1,1,1,0,1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,0), ncol = 7)

print(sprite)

render.matrix(sprite)

## -----------------------------------------------------------------------------
circle = render.makesprite('
  OOO
 O   O
O     O
O     O
O     O
 O   O
  OOO
')

render.matrix(circle)

## -----------------------------------------------------------------------------
box = matrix(1,8,16)
box[2:(nrow(box) - 1), 2:(ncol(box) - 1)] = 0

render.matrix(box)

## -----------------------------------------------------------------------------
sprite = render.makesprite('
 O O
 O O

O   O
 OOO
')

background = matrix(0,12,10)

#paste in sprites
background[1:5,1:5] = sprite
background[2 + 1:5, 5 + 1:5] = sprite
background[7 + 1:5, 3 + 1:5] = sprite

render.matrix(background)

## ----eval=F-------------------------------------------------------------------
#   overwrite = sprite
#   overwrite[sprite == 0] = matrix[a:b,c:d][sprite == 0]
#   #replace values of 0 with the value underneath
# 
#   matrix[a:b,c:d] = overwrite

## -----------------------------------------------------------------------------
background = matrix(0,9,9)

background[1:7,1:7] = circle

overwrite = circle
overwrite[circle == 0] = background[1 + 1:7,2 + 1:7][circle == 0] 
background[1 + 1:7,2 + 1:7] = overwrite

render.matrix(background)

## -----------------------------------------------------------------------------
background = matrix(0,9,14)

background = render.overlay(background, circle, 1, 1)
background = render.overlay(background, circle, 3, 3)
background = render.overlay(background, circle, 11, 1)

render.matrix(background)

## -----------------------------------------------------------------------------
scene = list(width=48, height=12)
block = upper.tri(matrix(1,12,32))[12:1,]

scene = render.sprite(scene,block,12,1)

txt = render.text('inversion\nof colors')

scene = render.sprite(scene,txt,2,1,layer='invert')

render.scene(scene)

## -----------------------------------------------------------------------------
sprite = render.makesprite('

 ...
.O=O.
.....
 ===
 
',lookup = c(' ' = 0, '.' = 1, '=' = 2, 'O' = 3))

render.matrix(sprite, palette=c('  ','..','==','()'))
render.matrix(sprite, palette=c('  ','..','++','\\/'))
render.matrix(sprite, palette=c('  ','||','MM','()'))

## -----------------------------------------------------------------------------
#manually stitching letters with a 1-wide gap between
render.matrix(
  cbind(
    fonts.3x3$sprites$T,
    matrix(0,3,1),
    fonts.3x3$sprites$E,
    matrix(0,3,1),
    fonts.3x3$sprites$X,
    matrix(0,3,1),
    fonts.3x3$sprites$T
  )
)

#render.text() does this automatically
render.matrix(
  render.text('text', kerning = 1)  
)

