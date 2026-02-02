

#I would LOVE for mario or a similar game to have a fancy scrolling layer background

#must explain screen coordinates! in vignette?



#' Render a Matrix to the Console
#'
#' Prints a matrix as pixels: characters coded by the matrix.\cr
#' By default, this prints in black&white with black pixels represented as `[]`:
#' ```
#'     []
#'   []  []
#' []      []
#'   [][][]
#' ```
#'
#' @param M Matrix to be drawn. Should contain only nonegative integers, corresponding to the desired characters to be drawn as defined by `palette`.
#' @param clear_console Wipes the console with `cat('\f')` before printing. This keeps the render in a consistent position.
#' @param palette An ordered vector of which character to draw when an element of M = 0, 1, 2, 3, 4, etc.
#' @section Default Palette:
#' The default matrix-to-character encoding (palette) is as follows:
#'
#' `0:`\verb{    }`: transparent`\cr
#' `1:`\verb{ [] }`: black`\cr
#' `2:`\verb{    }`: white`
#'
#' White and Transparent are usually printed identically, but their behavior differs elsewhere in the package. (i.e. when matrices are overlaid with [render.overlay()])
#'
#' @examples
#' smiley = matrix(c(0,0,1,0,0,0,0,1,1,1,0,1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,0), ncol = 7)
#' print(smiley)
#' render.matrix(smiley)
#'
#' #ASCII art
#' badger = matrix(c(0,3,0,0,0,2,1,0,2,0,0,2,1,0,2,0,0,2,0,3,0), ncol = 7)
#' render.matrix(badger, palette = c(' ', 'O', 'H', '='))
render.matrix = function(M, clear_console = FALSE, palette = c('  ', '[]', '  ')){
	cat(
		ifelse(clear_console,'\f',''),
		c('\n',palette)[rbind(t(M),-1) + 2],
		sep='')
}


#' Overlay Two Matrices
#'
#' @description
#' This function overlays two sprites, respecting transparency (values of 0).
#'
#' Specifically, `sprite` is placed on top of `background`, and its position can be altered by specifying `x` and `y`. Then the new `background` with the sprite atop it is returned; any part of `sprite` outside its bounds is ignored.
#'
#' @param background A sprite; a matrix of nonnegative integers corresponding to the pixels of a small image; see [render.matrix()].
#' @param sprite Another sprite to overlay on `background`.
#' @param x X coordinate of where the sprite should be drawn on the scene. Specifically, this determines the position of top-left pixel of the sprite.
#' @param y Y coordinate for the same purpose.
#' @param invert Whether or how `background` should have its colors inverted; see below.
#' @returns Returns `background` with `sprite` drawn on it.
#' @section Inversion:
#' Non-`FALSE` values of `invert` will invert the colors of `background` where `sprite` is opaque (nonzero).
#'
#' If `invert` is `TRUE`, `background` is assumed to be monochrome and values of 1 and 2 (black and white) are swapped.
#'
#' If `invert` is a vector of values, it will be used as an ordered lookup for how to invert the values `0, 1, 2, 3, etc.` in `background`. For example, `c(1,2,1)` will change 0->1, 1->2, and 2->1 and throw an error if `background` contains a value higher than 2.
#'
#' This is mainly to provide functionality for multicolor systems, where the function wouldn't know how to invert arbitrary values.
#' @section Conceptual Usage:
#' NOTE: this function will clip out any part of `sprite` that falls out of bounds of `background`; in these examples, the boxes are padded with extra space.
#' ```
#'    = 0 (transparent)
#' [] = 1 (black)
#' .  = 2 (white)
#'
#'
#' [][][][][]                    [][][][][]
#' []. . . []                    []. . . []
#' []. . . []     [][][][][]     []. [][][][][]
#' []. . . []  +  []. . . []  =  []. []. . . []
#' [][][][][]     []. . . []     [][][]. . . []
#'                []. . . []         []. . . []
#'                [][][][][]         [][][][][]
#'
#' Transparency:
#'
#' [][][][][]                    [][][][][]
#' []      []                    []      []
#' []      []     [][][][][]     []  [][][][][]
#' []      []  +  []      []  =  []  []  []  []
#' [][][][][]     []      []     [][][][][]  []
#'                []      []         []      []
#'                [][][][][]         [][][][][]
#'
#' Inversion:
#'
#' [][][][][]. .                     [][][][][]. .
#' [][][][][]. .                     [][][][][]. .
#' [][][][][]. .      [][][][][]     [][]. . . [][]
#' [][][][][]. .   ~  [][][][][]  =  [][]. . . [][]
#' [][][][][]. .      [][][][][]     [][]. . . [][]
#' . . . . . . .      [][][][][]     . . [][][][][]
#' . . . . . . .      [][][][][]     . . [][][][][]
#'
#' ```
#' ```{r}
#'   print('wow')
#' ```
#' [i hate these examples]
#' @examples
#' bg = matrix(2,7,7)
#'
#' box = matrix(1,5,5)
#' box.white = box; box.white[2:4,2:4] = 2
#' box.transparent = box; box.transparent[2:4,2:4] = 0
#'
#' #using pipes for conciseness; see ?pipeOp
#' #example 1
#' bg |>
#'   render.overlay(box.white) |>
#'   render.overlay(box.white, 3, 3) |>
#'   render.matrix()
#'
#' #transparency
#' bg |>
#'   render.overlay(box.transparent) |>
#'   render.overlay(box.transparent, 3, 3) |>
#'   render.matrix()
#'
#' #inversion
#' bg |>
#'   render.overlay(box) |>
#'   render.overlay(box, 3, 3, invert=TRUE) |>
#'   render.matrix()
render.overlay = function(background, sprite, x = 1, y = 1, invert = FALSE){
	#draws a sprite onto the scene

	width = ncol(sprite)
	height = nrow(sprite)

	xspan = x:(x + width - 1)
	yspan = y:(y + height - 1)

	#clip inbounds
	clipx = xspan > 0 & xspan <= ncol(background) #these are the inbound indices
	clipy = yspan > 0 & yspan <= nrow(background)

	xspan = xspan[clipx] #get only the inbound coordinates of the layer
	yspan = yspan[clipy]

	sprite = sprite[clipy, clipx, drop=FALSE] #get only the part of the sprite that's inbounds

	chunk = background[yspan, xspan, drop=FALSE] #the slice of the layer the chunk will overlay

	if (invert == FALSE) chunk[sprite != 0] = sprite[sprite != 0] #overlay non-transparent part of sprite
	else {
		if (invert == TRUE) invert = c(0,2,1,1,1,1,1,1,1,1,1,1,1)
		chunk[sprite != 0] = invert[1 + chunk[sprite != 0]] #invert background
	}

	background[yspan, xspan] = chunk

	return(background)
}


#' Sprite Animations
#'
#' Retrieves the current frame from a sprite animation. [todo examples]
#'
#' @details
#' A sprite defined in `ROM$sprites` can either be *simple* or *complex*;
#'
#' Simple sprites are just a static sprite matrix.
#'
#' Complex sprites are a list containing multiple frames of animation. Complex sprites can have the following properties:
#' |||||
#' |-|-|-|-|
#' |`$framerate`|\verb{  }||Framerate at which to play the animation.|
#' ||||
#' |`$next_animation`||spritename of which animation from ROM$sprites to play next when all frames of this one have played. If `NULL`, animation loops.|
#' ||||
#' |`$frames`||list of sprite matrices (simple sprites).|
#' ||||
#' |`$offset.x`||Offsets the location at which the sprite is drawn; see [render.object]|
#' ||||
#' |`$offset.y`||Offset relative to y.|
#'
#' Animated sprites can be tested using [render.test_animation()].
#' @returns
#' Returns a sprite matrix suitable for `render.sprite()`.
#' @param spritename String; name of sprite as defined in `sprites`.
#' @param timer Number of ticks elapsed since the animation started.
#' @param sprites `RAM$ROM$sprites`; list of sprites.
#' @param render_framerate `RAM$ROM$framerate`; game framerate.
#' @examples
#' #simple two-part animation using sprite$next_animation
#'
render.animate = function(spritename, timer, sprites, render_framerate = 60){ #timer = frame of animation
	sprite = sprites[[spritename]]

	if (is.null(sprite$framerate)) stop(paste('Sprite ',spritename,': No framerate set.',sep=''))

	n_frames = length(sprite$frames)
	frametime = ceiling(render_framerate/sprite$framerate) #assuming 60fps, # of frames for one frame of animation. e.g. 5 for a 12fps animation

	#next animation (otherwise just loops)
	if (!is.null(sprite$next_animation) && timer > n_frames * frametime) render.animate(sprite$next_animation, timer - n_frames * frametime, sprites, render_framerate)
	#this recursively goes through animations until it hits one that loops. usually not important, but it's nice and robust

	else {
		frame = (ceiling(timer/frametime) %% n_frames) + 1
		return(sprite$frames[[frame]])
	}
}


#' Test an Animated Sprite
#'
#'
#' [need to do an examples pass and adad examples to everyhting]
#' Plays a sprite's animation into the console. `^C` to stop.
#'
#' @param spritename Name of sprite in `sprites`
#' @param sprites List of sprites, e.g. `ROM$sprites`.
#'
#' @details
#' This function is intended to aid in the sprite creation process.
#'
#' It handles `sprite$next_animation` properly, so it can be used to test multi-stage animations too.
#'
#' [todo: examples with mario runcycle]
render.test_animation = function(spritename, sprites){
	timer = 1
	while (TRUE){
		frame = render.animate(spritename, timer, sprites, 60)

		render.matrix(frame, clear_console = TRUE)

		timer = timer + 1

		Sys.sleep(1/60)
	}
}


#' Generate Sprite Matrix from Text
#'
#' @description
#' The engine needs sprites to be a matrix of numbers, but this is inconvenient to do by hand. This function converts a string into a sprite to allow the dev to easily create sprites.
#'
#' By default, all non-space characters inputted will be converted to `1` (black) pixels in the sprite, and space characters to `0` (transparent).
#'
#' @param txt String to convert to matrix.
#' @param width Sprite width. This is usually set automatically.
#' @param default Number to which all characters not in `lookup` will be converted.
#' @param lookup Table for converting characters to non-`default` numbers.
#' @returns Returns a sprite matrix suitable for [render.matrix()].
#' @section Defaults:
#' The height of the sprite matrix is equal to the number of newlines in `txt`, as one might expect.
#' The width is determined by the rightmost non-space character, unless set manually.
#'
#' Characters in `txt` are converted 1-1 with numbers defined by `default` and `lookup`. The default character conversion is:
#' ||||
#' |-|-|-|
#' |\verb{        }`' '`:|\verb{ }|`0` (transparent)|
#' ||||
#' |\verb{        }`'.'`:||`0` (transparent)|
#' ||||
#' |\verb{        }`'_'`:||`2` (white)|
#' ||||
#' |everything else:||`1` (black)|
#'
#' @examples
#' smiley = render.makesprite('
#'   o o
#'   o o
#' o     o
#'  ooooo
#' ')
#'
#' render.matrix(smiley)
#'
#' #multicolor
#' palette =
#' badger = render.makesprite('
#'   O O
#' =     =
#'  HHHHH
#' ', lookup = c(' ' = 0, 'O' = 1, '=' = 2, 'H' = 3))
#'
#' print(badger)
#' render.matrix(badger, palette = c(' ', 'O', 'H', '='))
render.makesprite = function(txt, width = NULL, default = 1, lookup = c(' ' = 0, '.' = 0, '_' = 2)){
	data = strsplit(txt, '\n', fixed = TRUE)[[1]][-1] #removes leading \n
	data = trimws(data, 'right')

	#you typically don't need to set width, but it's sometimes useful for animations/consistency
	if (is.null(width)) width = max(nchar(data))
	height = length(data)

	M = matrix(0,height,width)

	for (row in 1:length(data)){
		string = strsplit(data[row], '' ,fixed = TRUE)[[1]]
		if (length(string)) for (char in 1:length(string)){
			val = lookup[string[char]]
			if (is.na(val)) val = default
			M[row,char] = val
		}
	}

	return(M)
}


