

#need a vignette or doc or something on resume timing, like RAM$began and stuff (and starting delayed). prolly write these when I do online



#' Resume Live Gameloop
#'
#' @description
#' The RAM needs several things to be set every time the gameloop starts:
#'
#' * `RAM$time` needs to be set to the current [time.sec()] for the gameloop's timing to work properly (see `vignette("timing")`).
#'
#' * `RAM$began` should be set to `c(time.sec(), RAM$ticks)` for inputs to be converted to the correct frame for processing (in [inputs.get]; see also `vignette("inputs")`)
#'
#' @param RAM [RAM][ram.init] object.
#' @param start_at Optional parameter to set the exact `time.sec()` when the RAM should start the gameloop; may be useful for syncing online play.
#' @examples
#' #only used internally. To resume gameplay, use RAM = ram.run(RAM).
#' @export
ram.resume = function(RAM, start_at = NULL){
	RAM$paused = FALSE

	if (is.null(start_at)) start_at = time.sec()
	RAM$time = start_at #set time to the current frame, so it won't try to violently rollback
	RAM$began = c(start_at, RAM$ticks)

	return(RAM)
}



#' Stop the Gameloop
#'
#' Exits [ram.run()] without printing an error traceback; the code equivalent of `^C`. This function is intended to be run in custom Game Code.
#'
#' Useful for Game Over scenarios, etc; see its usage in `vignette("snake")`.
#' @examples
#' print(Snake$end_game)
#' @export
ram.end = function(){
	stop('end')
	#ends the game process without printing error traceback
	#ram.run() has a special check for when the error message is 'end' like this to know not to print traceback
}




#' Set RAM RNG
#'
#' Sets the RAM's RNG with [base::set.seed()]. This is useful in `ROM$startup` if a dev wants their game to always use the same RNG seed, etc.
#'
#' @details
#' R's RNG is based on the `.Random.seed` global variable, which updates when a random call or set.seed() is called. RAM stores its own copy of this variable and temporarily restores it before running game code. Thus RNG ends up working as expected within a game, and will produce the same random calls when the game rolls back.
#'
#' Additionally, the RAM restores the R session's RNG after running game code, so the user's R environment is unaffected by random calls in the game.
#'
#' [WHY DOES THIS NOT WORK? I have confirmed that the RNG is set and stored properly with this function, not sure about in ram.tick]
#' @param RAM [RAM](ram.init) object.
#' @param seed Integer used for [base::set.seed].
#' @examples
#' \dontrun{
#' #example of a random situation:
#'
#' quickload(Snake)
#' #^C
#' quickload(Snake)
#' #the apple will have started in a different location.
#'
#' #fixing the RNG:
#' RAM = ram.init(Snake)
#' RAM = ram.set_rng(RAM, 42)
#' RAM = ram.run(RAM)
#'
#' #no matter how many times you run this, the apple will always spawn in the same location.
#' }
#' @export
ram.set_rng = function(RAM, seed){
	global_RNG = .Random.seed #back up actual RNG seed to restore at the end of function to comply with "leave no trace"

	set.seed(seed)
	RAM$rng = .Random.seed

	.Random.seed <<- global_RNG #restore original RNG

	return(RAM)
}




#' Backup RAM
#'
#' Creates a backup of RAM. This is different from a full copy (e.g. `my_copy = RAM`):
#' ||||
#' |-|-|-|
#' |Copy|\verb{  }|A full copy of the RAM; this will restore the full state of the RAM, deleting any inputs or debug info that may have happened since.|
#' ||||
#' |Backup||A backup of most RAM data, but excluding inputs and debug information; these will be preserved if the backup is restored.|
#'
#' The game uses this to periodically back up the gamestate so that it can restore it in a [rollback][ram.rollback].
#'
#' @param RAM [RAM](ram.init) object.
#' @returns RAM, minus `$ROM, $inputs, $debug, $intermediate, $backup,` and `$paused`.\cr This output is stored in the main RAM's `$intermediate` and `$backup`.
#' @examples
#' \dontrun{
#' RAM = ram.init(SuperRrio)
#'
#' #copy
#' RAM_copy = RAM
#' print(names(RAM_copy))
#'
#' #backup
#' RAM_backup = ram.backup(RAM)
#' print(names(RAM_backup))
#' }
#' @export
ram.backup = function(RAM){
	return(RAM[!(names(RAM) %in% c('ROM', 'inputs', 'debug', 'intermediate', 'backup','paused'))])	#exclude the backups and ROM from being copied into the backups
}




#' Add an Unnamed Object to RAM$objects
#'
#' @description
#' Puts `object` into `RAM$objects` without assigning it a name. This is useful when iteratively creating objects that will not be referenced by name--- see the `Snake` vignette for an example of this.
#'
#' Otherwise, objects should be put in `RAM$objects` like so for easy reference:
#' ```
#' RAM$objects$my_object = list(...)
#' print(RAM$objects$my_object)
#' ```
#'
#' @param RAM [RAM](ram.init) object.
#' @param object Game object; a list with properties like `$x` and `$spritename`.
#' @details
#' Convenience function for `RAM$objects = c(RAM$objects, list(object))`. This is because the syntax for adding a nested list to a list is `c(listA, list(listB))`!
#'
#' Nested lists in R can be confusing, so it's better to have a function that does this automatically than to trust users to remember the correct syntax.
#' @examples
#' RAM = ram.init(rom.init(16,8))
#'
#' #named object
#' RAM$objects$blueberry = list(x=1,y=5,sprite='blueberry',layer=4)
#'
#' #unnamed object
#' RAM = ram.new_object(RAM, list(x=1,y=5,sprite='fruit',layer=3))
#'
#' print(RAM$objects)
#' @export
ram.new_object = function(RAM, object){
	RAM$objects = c(RAM$objects, list(object))

	return(RAM)
}




#' Game Debug Info
#'
#' @description
#' `RAM$debug` contains a host of data from the RAM's recent gameplay, relevant to the timing and rollback systems (`vignette("timing")` and `vignette("rollback")`). This is mostly useful for internal debugging (i.e. by the package dev), especially for online play.
#'
#' This function prints out some timing-related debug information.
#' @section RAM$debug:
#' `RAM$debug` contains the following elements:
#' ||||
#' |-|-|-|
#' ||||
#' |`$time`||For each frame, [time.sec()] at the start of the frame. Useful as an x-axis for plotting other elements.|
#' ||||
#' |`$ahead`||At the end of each frame, how far ahead the RAM is from the end of this frame; (`RAM$time - time.sec()`). If this is negative, the RAM is lagging behind.|
#' ||||
#' |`$input.behind`|\verb{  }|For any inputs received on this frame, time between their timestamp and RAM$time|
#' ||||
#' |`$time.tick`||For each frame, time it took to run [ram.tick()].|
#' ||||
#' |`$time.draw`||For each frame, time it took to run [render.ram()].|
#' ||||
#' |`$time.inputs`||For each frame, time it took to run [inputs.get()] and [inputs.process()].|
#' ||||
#' |`$rollbacks`||For each occurrence of a rollback ([ram.rollback()] call), records the [time.sec()] at which it happened.|
#' ||||
#' |`$frames`||For each frame, the value of `RAM$ticks`; the current tick the RAM is at. Makes rollbacks a more obvious than buffer.|
#' ||||
#' |`$frames.drawn`||Records every frame of `RAM$ticks` that was drawn by [render.ram()], i.e. when `ahead` was positive (see `vignette("timing")`).|
#' @param RAM [RAM](ram.init) object.
#' @examples
#' \dontrun{
#' #plot ram.time() over time to see rollbacks:
#' plot(RAM$debug$time, RAM$debug$ahead, type='l')
#'
#' #compare which parts of each frame took up the most time
#' plot(rowSums(cbind(
#'		RAM$debug$time.tick,
#'		RAM$debug$time.inputs,
#'		RAM$debug$time.draw
#' ),na.rm=TRUE), type='l', main='seconds per tick by parts')
#' lines(RAM$debug$time.tick, col='blue')
#' lines(RAM$debug$time.draw, col='red')
#' lines(RAM$debug$time.inputs, col='green')
#' legend('topleft',pch=15,pt.cex=2,legend=c('total','tick','draw','input'),title='step',col=c('black','blue','red','green'))
#' }
#' @export
ram.debug = function(RAM){
	plot(RAM$debug$time, RAM$debug$ahead, type='l', main='Lag by time')
	abline(h=0)

	cat(
	'\nSee ?ram.debug for more info',
	sep='')
}




