


#' 3x3 Font
#'
#' @description
#' Basic [font][render.makefont] with no lowercase. Readability is poor, but this produces the most compact text possible.
#'
#' Use this with [render.text()].
#' @format A [font][render.makefont]; a list containing font-related properties and a list of sprites for each character.
#' @seealso `fonts.3x5`
'fonts.3x3'

#' 3x5 Font
#'
#' @description
#' Basic [font][render.makefont] with all common characters. Horizontally compact, but much more readable than [fonts.3x3]. This should be the preferred low-res font for most situations.
#'
#' Made by yours truly. Some of these sprites are pretty snazzy.
#'
#' Use this with [render.text()].
#' @format A [font][render.makefont]; a list containing font-related properties and a list of sprites for each character.
#' @seealso `fonts.3x3`
'fonts.3x5'


#' Snake Game
#'
#' Plays the classic game Snake. A full walkthrough of the creation of this ROM can be found in `vignette("snake")`.
#' @format A game [ROM][rom.init]; see `vignette("engine")`.
#' @section How to Play:
#' WASD to move the snake. `ENTER` *must* be pressed after each input for it to be registered.
#'
#' Follow these steps:
#'
#' 1. `quickload(Snake)`
#' 2. Follow console prompt.
#' 4. Open new R session and load `rcade` with `library(rcade)`.
#' 5. `inputs.listen()` in that new session.
#' 6. Use WASD to control snake.
#'
#' When you run `quickload()`, the game will ask if you want to keep the default settings or input your own. The default settings are:
#'
#' `5` frames per second\cr
#' `32x16` bounding area\cr
#' `10` starting snake length\cr
'Snake'






#' Bad Apple
#'
#' @description
#' A ROM that plays the video [Bad Apple](https://www.youtube.com/watch?v=FtutLA63Cp8).\cr
#' See `vignette("badapple")` for more details.
#'
#' ```
#' RAM = ram.init(BadApple); RAM = ram.run(RAM)
#' ```
#' You may have to zoom out a bit with `cmd -`.
#'
#' `BadApple.data` stores the compressed video frames, which are decompressed in `BadApple$startup()`.
#'
#' @format |`BadApple`|\verb{      }|A [ROM][rom.init] object.|
#' |-|-|-|
#' @details
#' This is a proof of concept for rendering video in rcade. It's actually easier to render video by reading from a local file, but to fit a video to come preinstalled with the package, I had to compress it.
#'
#' `BadApple$startup()` reconstructs the video when the RAM is initialized, saving the resultant frames as a single animation in `RAM$ROM$sprites`. A single object then loops the animation constantly.
#'
#' The frames are from [https://github.com/Timendus/chip-8-bad-apple](https://github.com/Timendus/chip-8-bad-apple).
#' @section Compression:
#' `BadApple.data` is an ordered list of vectors, with each vector corresponding to a frame. Each vector stores the indices of which pixels should flip (`black <-> white`) compared the previous frame; this allows the video to be iteratively reconstructed losslessly starting from a blank frame.
#'
#' Much stronger forms of compression have been devised for Bad Apple projects, but this is a simple, naive approach that works well enough (50 -> 1MB) for the application. More importantly, rcade shouldn't really require compressed videos since you can read frames directly from a file.
'BadApple'

#' @rdname BadApple
#' @format |`BadApple.data`|\verb{ }|Compressed video frames; a list of vectors indicating which pixels flip each frame.|
#' |-|-|-|
'BadApple.data'
