

#fix everything to have $element in the descriptions if they need it
#do a units pass for arguments


#do a pass where frame and tick are clarified as being the same thing(?)



#' Create ROM Object
#'
#' @description
#' A ROM object contains all the static data for running a game. ROM elements can be set with this function or after the fact, e.g. with `ROM$framerate = 30`.
#'
#' See `vignette("engine") for more info.
#' @section Game Code:
#' `ROM$custom` updates the RAM every frame in [ram.tick()]. All game code should be either in `ROM$custom` or in helper functions stored in the ROM, demonstrated below.
#' @examples
#' testrom = rom.init(64,16)
#' testrom$example_function = function(){print('foo')}
#' testrom$startup = function(RAM){RAM$ROM$example_function(); return(RAM)}
#' RAM = ram.init(testrom)
#' @param screen.width Width of the game screen in pixels; see [render.scene].
#' @param screen.height Height of the game screen in pixels.
#' @param framerate Frames per second the game should run at. 60 recommended, 30 may be useful if [render.ram()] takes a significant amount of time.
#' @param backup_duration How frequently the RAM backs itself up in seconds; see [ram.rollback]. Shouldn't need to be changed from the default.
#' @param keybinds Vector of keys and their corresponding action; see [inputs.process()].
#' @param startup Function run by the game when initialized with [ram.init()]. Must return `RAM`.
#' @param custom Function run by the game on every frame with [ram.tick()]. Must return `RAM`.
#' @param sprites List of all sprites (matrices) used by the game; see [render.animate].
#' @param palette Vector of how each value of 0, 1, 2, 3, etc. in a sprite should be drawn by [render.matrix()].
#' @param input_delay Seconds to add to the timestamp of every input. Makes inputs get processed slightly after they were sent, to reduce the frequency of rollbacks.
rom.init = function(
		screen.width, screen.height,
		keybinds = c(w = 'up', a = 'left', s = 'down', d = 'right'),
		startup = function(RAM){return(RAM)},
		custom = function(RAM){return(RAM)},
		sprites = list(),
		palette = c('  ','[]','  '),
		framerate = 60, backup_duration = 2, input_delay = 1/60
){
	ROM = list(
		framerate = framerate,
		backup_duration = backup_duration,
		screen.width = screen.width,
		screen.height = screen.height,
		keybinds = keybinds,
		startup = startup,
		custom = custom,
		sprites = sprites,
		palette = palette,
		input_delay = input_delay
	)
	class(ROM) = 'ROM'

	return(ROM)
}



#' Create RAM Object
#'
#' Uses a game ROM object to create a RAM object, which stores all dynamic data of the game. As [ram.run()] runs the game, the RAM is updated and read.
#'
#' @param ROM [ROM][rom.init] object containing game code.
#' @returns A RAM object contains the following elements.
#' ||||
#' |-|-|-|
#' |`ROM`|\verb{  }|ROM object the game is run with.|
#' ||||
#' |`ticks`||Number of frames the game has processed.|
#' ||||
#' |`time`||Time of the latest frame reached by the RAM.|
#' ||||
#' |`rng`||[WRITEHERE] see [ram.set_rng]|
#' ||||
#' |`seed`||Integer used to [set the rng][set.seed] during ram.init. Random by default.
#' ||||
#' |`objects`||List of game-related objects; dynamic game data should generally be stored here. Objects in this list which have a `$spritename` are drawn in [render.ram()].|
#' ||||
#' |`inputs`||List of all inputs the game has received, matching `inputs.csv`. See [inputs.process()].|
#' ||||
#' |`actions`||List of all game actions that are currently active|
#' ||||
#' |`n_inputs`||Number of inputs from `inputs.csv` the RAM has read. Used to determine which are new.|
#' ||||
#' |`backup`||Copy of RAM from a couple seconds ago, excluding `$ROM`, `$inputs`, `$debug`, `$backup`, and `$intermediate` (since these shouldn't be rolled back). See [ram.rollback]|
#' ||||
#' |`intermediate`||Same as `$backup`, but more recent. Used in [ram.tick()] to update `$backup` on a rolling basis.|
#' ||||
#' |`began`||Vector of c(time,tick) indicating when [ram.run] was last run, used for timing inputs.|
#' ||||
#' |`paused`||Boolean; is the game allowed to tick?|
#' ||||
#' |`debug`||Collection of info about the current game session; see [ram.debug].|
#' @section Notes:
#' Custom game code (in [`RAM$ROM$custom`][rom.init]) should typically only modify `RAM$objects`. This makes inspecting and handling the RAM more consistent across games.
ram.init = function(ROM){
	#wipe inputs (clear inputs.csv)
	inputs = data.frame(timestamp = -1, text = 'init') #initialize input frame
	utils::write.csv(inputs, paste(tools::R_user_dir('rcade'),'/inputs',sep=''), row.names=FALSE) #wipe old file

	RAM = list(
		ROM = ROM, #R stores data in such a way that this isn't a concern; it's essentially a pointer unless we alter the ROM. this has a great explanation: https://bookdown.dongzhuoer.com/hadley/adv-r/copy-on-modify

		ticks = 1, #number of ingame ticks since startup
		time = 0, #time of the most recent frame the ram executed (set when the game starts)

		objects = list(), #list of objects

		n_inputs = 1, #number of inputs in `inputs.csv` processed
		inputs = data.frame(timestamp = -1, text = 'init'),
		actions = {\(){actions = as.list(rep(FALSE,length(ROM$keybinds)));
			names(actions) = ROM$keybinds
			return(actions)}}(),  #list of states for each action: pressed, held, released

		intermediate = list(), #intermediate backup so rollbacks always have maximum duration (MAXIMUM? YOU SURE?)
		backup = list(), #backup of RAM that gets loaded on a rollback

		began = c(time.sec(),1), #c(time,tick) of the most recent time the game resumed with ram.run
		paused = FALSE,

		rng = c(), #actual stored RNG
		seed = sample(1:65535,1), #initial RNG seed

		debug = list(
			#by frame:
			time = NULL, #time at the start of each frame.
			ahead = NULL, #after ticking, time ahead of the current frame. negative on draw frames; positive on rollback frames
			input.behind = NULL, #time difference between RAM$time and a new input
			#input.behind is MESSSYYY

			time.tick = NULL, #time it took to tick
			time.draw = NULL, #time it took to draw
			time.inputs = NULL, #time it took to read inputs

			#by occurence:
			rollbacks = NULL, #timestamps of each rollback

			frames = NULL,  #tick number of every frame
			frames.drawn = NULL #tick number of every drawn frame
		),

		inputs = list() #TODO
	)
	class(RAM) = 'RAM'

	RAM = ROM$startup(RAM) #startup code

	RAM = ram.set_rng(RAM, RAM$seed) #initialize RNG using RAM seed. (seed can be defined on a per-ROM basis in ROM$startup, otherwise it's random per-RAM)

	return(RAM)
}




#' Common Issues
#'
#' @description
#' Unexpected crash? This documentation provides debugging resources and lists some common problems you might encounter.
#'
#' The Snake vignette is goes through the basic development process and is very useful; you can view it with `vignette("Snake")`.
#'
#' @section Traceback:
#' When the game crashes, it prints a `traceback, call, and error`:
#' ||||
#' |-|-|-|
#' |Traceback|\verb{  }|A list showing which functions led to where the error is. Should be similar to what you get from base R's [traceback()].|
#' |Call||The call in which the error occurred.|
#' |Error||The specific error.|
#'
#' [`?ram.run`][ram.run] has a function tree of that may be useful in understanding where an error occurred; the traceback will list the branches encompassing the error call.
#'
#'
#' @section Logging:
#' Multiple options exist for printing information via game code.
#'
#' - The contents of `RAM$echo` are printed below the game render every frame.
#'
#' - Any `base::print()` calls will only be visible *if the game crashes* due to how the console is wiped.
#'
#' - A global variable `foo <<- [debug info]` can be modified via the game code.
#'
#' Thus `print()` is ideal for debugging the source of a crash, as it prints information about the current tick. `RAM$echo` is useful for monitoring values while running the game, and using a global variable gives more control and the option to record info for every tick.
#'
#' @section Timing:
#' [RAM$debug][ram.debug] records a lot of timing-related data relevant to the timing and rollback systems (`vignette("timing")` and `vignette("rollback")`).
#'
#' @section Empty Lists:
#' Make sure you haven't accidentally wiped RAM or `RAM$objects`. This can happen if you define a custom function like `ROM$my_function(RAM)` and forget to return RAM at the end of it.
#'
#' @section Inputs:
#' Make sure that `tools::R_user_dir("rcade")` exists.
#'
#' Double-check `ROM$keybinds` and make sure `RAM$actions` are properly referenced in your code. Consider adding ```RAM$echo = RAM$actions``` to `ROM$custom` to show the state of each action every tick.
#'
#' @section Iterating:
#' To iterate through `RAM$objects`, use the syntax
#' ```
#' for (i in 1:length(RAM$objects)){
#'		obj = RAM$objects[[i]]
#'
#' }
#' ```
#' This is required due to how R handles nested lists; the format\cr `for (obj in RAM$objects)` will **NOT** work.
rom.help = function(){
	cat('See ?rom.help for help debugging common issues.')
}

#' @rdname rom.help
ram.help = rom.help


