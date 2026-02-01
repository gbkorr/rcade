


#' Render a Sprite to the Scene
#'
#' [I quite dislike this @example sir]
#' Overlays a sprite onto the desired layer of the [`scene`][render.scene] using [render.overlay()].
#' @param scene [Scene][render.scene] object.
#' @param sprite Matrix of nonnegative integers corresponding to the pixels of a small image; see [render.matrix()].
#' @param x X coordinate of where the sprite should be drawn on the scene. Specifically, this determines the position of top-left pixel of the sprite.
#' @param y Y coordinate for the same purpose.
#' @param palette Vector to swap the colors (numbers) of the sprite around, e.g. `c(0,2,1)` swaps values of 2 and 1. Index starts at 0. Defaults to no swapping.
#' @param layer Layer on which the sprite should be drawn. Higher layers are drawn on top.
#' @returns Returns the [scene][render.scene] object with sprite drawn.
#' @examples
#' scene = list(width=24, height=6)
#' smiley = matrix(c(0,0,1,0,0,0,0,1,1,1,0,1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,0), ncol = 7)
#' box = matrix(1,12,9)
#' scene = render.sprite(scene, smiley, x=2, y=2)
#' scene = render.sprite(scene, smiley, x=11, y=2, layer = 2, palette = c(0,2,1)) #reversed colors
#' scene = render.sprite(scene, box, x=10, y=1)
#' render.scene(scene)
render.sprite = function(scene, sprite, x, y, layer = 1, palette = NULL){
	#draws a sprite onto the scene

	#palette swap
	if (!is.null(palette)) sprite = matrix(palette[sprite + 1], nrow = nrow(sprite), ncol = ncol(sprite))

	#create layer
	if (length(scene$layers) < layer || is.null(scene$layers[[layer]])){ #highest layer yet, or layer not yet set
		scene$layers[[layer]] = matrix(0,scene$height,scene$width)
	}

	scene$layers[[layer]] = render.overlay(scene$layers[[layer]], sprite, x, y)

	return(scene)
}


#' Draw an Object to the Scene
#'
#' @description
#' Calls [render.sprite()] using an object's `$spritename` (the name of the desired sprite in `RAM$ROM$sprites`).
#'
#' The object is drawn at position `(obj$x, obj$y)` on layer `obj$layer` if specified (see below).
#'
#' Objects with no `$spritename` will not be drawn, unless they have custom drawing behavior defined in `obj$draw()`:
#'
#' If the object has a function set for `obj$draw()`, it will be run instead of `render.sprite()`. This allows the game dev to create custom drawing behavior.
#' ```
#' scene = obj$draw(scene, obj, RAM)
#' ```
#' @param scene [Scene][render.scene] object.
#' @param obj Object in `RAM$objects`. Objects with a `$spritename` will be drawn.
#' @param RAM [RAM][ram.init] object.
#' @returns Returns the [scene][render.scene] object with sprite drawn. This function is called by [render.ram()] for each object in `RAM$objects`.
#' @details
#' An object only needs a `$spritename` to be drawn. Objects can also have the following properties which influence how they're drawn: otherwise, the default value (second column) will be used.
#' |||||
#' |-|-|-|-|
#' |`$spritename`|||Name of sprite in `ROM$sprites`.|
#' ||||
#' |`$x`|\verb{ }|`1`|X-coordinate at which to draw the object's sprite in the scene.|
#' ||||
#' |`$y`||`1`|Y-coordinate.|
#' ||||
#' |`$layer`||`2`|Layer on which to draw the sprite. See [render.scene]; high layers are drawn on top.|
#' ||||
#' |`$timer`||`RAM$timer`\verb{ }|Tick count (ascending) for animations.|
#' ||||
#' |`$palette`||`NULL`|Vector to swap the colors of the object's sprite around, e.g. `c(0,2,1)` swaps values of 2 and 1. Index starts at 0. Defaults to no swapping.
#' ||||
#' |`$draw()`||`NULL`|Overwrites the default drawing behavior for the sprite; see above.|
render.object = function(scene, obj, RAM){

	#custom draw code
	if (!is.null(obj$draw)) scene = obj$draw(scene, obj, RAM)

	#if the object has no sprite then it's not drawn
	else if (!is.null(obj$spritename)) {
		sprite = RAM$ROM$sprites[[obj$spritename]] #get sprite data from ROM

		#object drawing defaults
		draw = utils::modifyList(list(
			x = 1,
			y = 1,
			palette = NULL,
			layer = 2
		), obj) #defaults replaced if defined in obj

		#complex sprite
		if (is.list(sprite)) {
			#static sprite offset from xy
			draw$x = sum(draw$x, sprite$offset.x, na.rm = TRUE)
			draw$y = sum(draw$y, sprite$offset.y, na.rm = TRUE)

			draw$timer = obj$timer
			if (is.null(draw$timer)) draw$timer = RAM$ticks #if no timer provided

			sprite = render.animate(obj$spritename, draw$timer, RAM$ROM$sprites, RAM$ROM$framerate) #retrieve which matrix to draw for animation
		}

		scene = render.sprite(scene, sprite, draw$x, draw$y, draw$layer, draw$palette)
	}

	return(scene)
}

#could also be neatened



#' Render Scene to Console
#'
#' @description
#' Renders a scene object to the console by stacking its layers.\cr
#' Each layer is a matrix drawable by [render.matrix()], and the layers are iteratively stacked with [render.overlay()].\cr
#' The highest layer is drawn on top.
#' @param scene Scene object to be rendered; see below.
#' @param clear_console Should the console be wiped before rendering the scene? This keeps the render in a consistent position.
#' @param palette An ordered vector of which character to draw when an element of M = 0, 1, 2, 3, 4, etc. Typically this is ROM$palette, which has the same default.
#' @section Scene:
#' The scene object has the following properties:
#' ||||
#' |-|-|-|
#' | `$width` |\verb{  }| Width of scene in pixels. Should match `ROM$screen.width`. |
#' ||||
#' | `$height` || Height of scene in pixels. Should match `ROM$screen.height`. |
#' ||||
#' | `$layers` || Ordered list of matrices representing each layer. All layers are of size `(width,height)`.
#' @section Inversion:
#' The scene also has a `scene$layers$invert` layer; anything drawn to this (e.g. with `render.sprite(...layer = 'invert')`) will [invert][render.overlay] the colors of the rendered scene. This is useful for text.
#' @section See Also:
#' To render a sprite onto a scene layer, [render.sprite()]\cr
#' To render an object onto the scene, [render.object()]
#'
#' The gameloop creates and renders the scene in [render.ram()]
#' @examples
#' #basic layering
#' scene = list(width=16, height=16)
#' box = matrix(c(1,1,1,1,1,1,2,2,2,1,1,2,2,2,1,1,2,2,2,1,1,1,1,1,1), ncol = 5)
#' for (i in 1:5) scene = render.sprite(scene, box, x=2*i, y=2*i, layer=6-i)
#' render.scene(scene)
#'
#' #inversion layer
#' bigbox = matrix(1,11,11)
#' scene = render.sprite(scene, bigbox, x=1, y=1, layer='invert')
#' render.scene(scene)
render.scene = function(scene, clear_console = FALSE, palette = c('  ', '[]', '  ')){
	#scene = list(width, height, layers = matrices list(1, 2, 3, 4))

	if (is.null(scene$height)) stop('Invalid scene object! Did you forget to pass it somewhere?')

	canvas = matrix(2,scene$height,scene$width) #blank white background to draw everything onto

	#handle invert layer
	invert_layer = NULL
	if (!is.null(scene$layers$invert)){
		invert_layer = scene$layers$invert
		scene$layers$invert = NULL #remove so it doesn't get drawn with the others
	}

	for (layer in scene$layers){
		if (!is.null(layer)) canvas = render.overlay(canvas, layer) #skip empty layers.
	}

	#inversion layer
	if (!is.null(invert_layer))	canvas = render.overlay(canvas,invert_layer,invert=TRUE)

	render.matrix(canvas, clear_console, palette = palette)
}



#' Draw the RAM
#'
#' Draws RAM at the current tick by drawing each object in `RAM$objects` that has a sprite.
#' @param RAM [RAM](ram.init) object to draw.
#' @param clear_console Should the console be wiped before rendering the scene? This keeps the render in a consistent position.
#' @details
#' This creates a scene object with size `(RAM$ROM$screen.width, RAM$ROM$screen.height)`,\cr calls [render.object()] on every object to draw them onto this scene,\cr and then calls [render.scene()].
render.ram = function(RAM, clear_console = FALSE){
	scene = list(width = RAM$ROM$screen.width, height = RAM$ROM$screen.height)

	if (length(RAM$objects) == 0) stop('RAM$objects is empty!')

	for (i in 1:length(RAM$objects)) { #strangely, (obj in RAM$objects) produces all atomic values in the nested lists. we only want the objects themsleves
		obj = RAM$objects[[i]]
		scene = render.object(scene, obj, RAM)
	}

	render.scene(scene, clear_console, RAM$ROM$palette)

	for (echo in RAM$echo) cat(echo,'\n',sep='')
}

