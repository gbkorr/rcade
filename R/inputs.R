

#need a vignette or doc or something on resume timing, like RAM$began and stuff

#somewhere: RAM$echo = RAM$ticks can be useful


#' Record Player Inputs
#'
#' @description
#' `inputs.listen()` listens for input and writes all entered text into the `inputs.csv` file in the [package directory][tools::R_user_dir].
#'
#' `inputs.listen()` should be run in a **separate RStudio instance** from where the game is running. This allows the game to read player input without interruption.
#'
#' `inputs.read()` reads this `inputs.csv` file; it is called in the [main gameloop][ram.update] to retrieve live player input.
#'
#' Each input is only submitted when the `Enter` key is pressed. This can make interacting with the game initially challenging.
#' @details
#' An 'input' is a string of text with a timestamp corresponding to when the game should [process][inputs.process] the input.
#'
#' Inputs are stored as rows in the `inputs.csv` dataframe, which has the following columns:
#' ||||
#' |-|-|-|
#' |`timestamp`|\verb{  }|[time.sec()] at which the input was entered plus a small delay (see arguments).|
#' ||||
#' |`text`||String that was entered at this timestamp. Each character will be parsed by the game as an individual key input. |
#'
#' `inputs.listen()` adds a new row to `inputs.csv` each time `Enter` is pressed.
#' @seealso
#' `vignette("inputs")` gives an overview of each part of the input system.
#'
#' [?inputs.process][inputs.process] provides a more focused description of how an input gets from the player's keyboard to the game code.
#'
#' @section inputs.csv:
#' `inputs.csv` is stored in [`tools::R_user_dir('rcade')`][tools::R_user_dir], the directory for storing package data.
#'
#'  Only one `inputs.csv` file exists and is read by the package; the file is wiped every time [ram.init()] is called.
inputs.listen = function(){
	path = paste(tools::R_user_dir('rcade'),'/inputs',sep='')

	cat('Listening for inputs...')
	while(TRUE){
		text = readLines(n=1) #preserves whitespace
		input = matrix(c(time.sec(), text), ncol=2)
		utils::write.table(input, path, row.names=FALSE, col.names=FALSE, append=TRUE, sep=',')
	}
}

#' @rdname inputs.listen
inputs.read = function(){
	tryCatch({
			return(utils::read.csv(paste(tools::R_user_dir('rcade'), '/inputs', sep='')))
		}, error = function(void){return(data.frame(timestamp = 0, text = 'init'))} #return empty inputs if an error occurs
	)

	#this trycatch fixes an obscure error, maybe from trying to read inputs.csv while listener is writing to it?
}


#' Manually Add an Input to RAM
#'
#' Allows the user to input to RAM while RAM is not being run.
#' @param RAM [RAM][ram.init] object.
#' @param input Input to add to RAM$inputs. Exactly what you might type in the input session.
#' @param timestamp Specific tick set the input for. `NULL` sets the input to be processed on the next tick.
#' @details
#' Adds an input to `RAM$inputs` as if it were a new input in `inputs.csv`. The input is set to occur on the next tick unless specified by `timestamp`.
ram.input = function(RAM, input, timestamp = NULL){
	if (is.null(timestamp)) timestamp = RAM$ticks #next frame

	RAM$inputs = rbind(RAM$inputs, c(timestamp, input))

	return(RAM)
}


#' Read Inputs with RAM
#'
#' @description
#' Retrieves new inputs with [inputs.read()], converts their timestamp to the tick the game should process them on, and saves them to `RAM$inputs`.\cr
#' If any of these new inputs should have occurred on a prior tick, [rolls back](ram.rollback) to resolve the dropped input.
#'
#' See `vignette("inputs")` for more details.
#' @details
#' New inputs are inputs which exist in `inputs.csv` but not in `RAM$inputs`.
#'
#' The tick an input should occur on is calculated as:
#' ```
#' RAM$began[2] +
#' ceiling(
#'		RAM$ROM$framerate * (
#'				newinputs$timestamp +
#'				RAM$ROM$input_delay -
#'				RAM$began[1]
#'		)
#' )
#' ```
#' Where `RAM$began` stores the `c(timestamp, tick)` of the last time [ram.run()] was called, `ROM$input_delay` is the desired delay between inputting a key and when the game should register it, and `ROM$framerate` is the desired framerate of the game.
#'
#' New inputs occurring before the last call of ram.run, i.e. those from before the game started or while the game was paused, have their tick set to `-1` so they will never be registered.
#'
#' Then `RAM$inputs` is updated to contain all the new inputs, matching `inputs.csv`.
#' @param RAM [RAM](ram.init) object to update.
inputs.get = function(RAM){
	inputs = inputs.read()
	n_new = nrow(inputs)
	n_old = RAM$n_inputs

	#check new inputs for any behind the current frame
	if (n_new > n_old){ #if there are any new inputs
		newinputs = inputs[(n_old+1):n_new,]

		if (RAM$paused) newinputs$timestamp = RAM$ticks #while paused, all inputs are queued for this tick
		else {
			newinputs$timestamp = RAM$began[2] + ceiling((newinputs$timestamp + RAM$ROM$input_delay - RAM$began[1]) * RAM$ROM$framerate) #convert to frames
			newinputs[newinputs$timestamp < RAM$began[2]]$timestamp = -1 #ignore inputs from when the game was paused or before the game started
		}

		#commands
		commands = substr(newinputs$text,1,1) == '/'
		newinputs[commands]$timestamp = -1 #ignore as inputs
		for (command in newinputs[commands]$text){
			RAM = inputs.command(RAM, command)
		}

		#RAM$debug$input.behind = c(RAM$debug$input.behind, max(behind))
		if (sum(newinputs$timestamp < RAM$ticks & newinputs$timestamp > RAM$backup$ticks)) {
			RAM = ram.rollback(RAM) #if any new inputs are behind, roll back
		}

		RAM$inputs = rbind(RAM$inputs, newinputs)
		RAM$n_inputs = RAM$n_inputs + nrow(newinputs)
	} #else RAM$debug$input.behind = c(RAM$debug$input.behind, NA)

	return(RAM)
}





#' Apply Inputs
#'
#' @description
#' Updates `RAM$actions` according to any inputs occurring on the current frame.
#'
#' Inputs and actions are stored in RAM like so:
#' ||||
#' |-|-|-|
#' |`RAM$inputs`|\verb{  }|Stores every input that ever occurred, just like [`inputs.csv`](inputs.read).|
#' ||||
#' |`RAM$actions`||Stores the game actions corresponding to inputs as dictated in `ROM$keybinds` (see below).|
#'
#' @details
#' The following is an outline of the process from a player entering an input to it being registered by the game.
#' 1. Player types out "wa" in the [inputs.listen()] listener.\cr
#' 2. Player presses Enter; an input is created consisting of the string `"wa"` and a timestamp (see [inputs.listen]).\cr
#' This input is written to [`inputs.csv`](inputs.read).\cr
#' 3. When the gameloop runs [inputs.get()], this input is added to `RAM$inputs` and its timestamp is converted to the tick it should be processed on.\cr
#' 4. When `RAM$ticks ==` the tick timestamp of this input in `RAM$inputs`, the input is processed:\cr
#' 5. The input is split into individual characters: `"w"` and `"a"`.\cr
#' 6. The actions corresponding to these keys, `RAM$ROM$keybinds["w"] and RAM$ROM$keybinds["a"]`, are set to `TRUE` in `RAM$actions` (see below).\cr
#' 7. Game code in `RAM$ROM$custom()` reads `RAM$actions` and move the player character accordingly.
#' 8. On the next frame, all `RAM$actions` are set to FALSE before inputs are checked again.
#' @section Keybinds:
#' Keybinds are set by the dev with, e.g.
#' ```
#' ROM$keybinds = c(k = 'attack', w = 'up', a = 'left', s = 'down', d = 'right')
#' ```
#'
#' This stores the actions ('attack', 'up', etc.) and the keys (k, w, etc.) that, when input, activate the actions.
#' These keybinds populate `RAM$actions` when RAM is [initialized](ram.init):
#' ```
#' RAM$actions = c(attack = FALSE, up = FALSE, left = FALSE, down = FALSE. right = FALSE)
#' ```
#'
#' When a key is registered, the corresponding action in `RAM$actions` is set to TRUE for one frame.
#'
#' The game should read RAM$actions to control game behavior; see `vignette('rrio')` to see this in action.
#' @param RAM [RAM](ram.init) object to update.
inputs.process = function(RAM){
	#deactivate actions
	RAM$actions[RAM$actions == TRUE] = FALSE

	#inputs falling between now and the next frame
	current_frame_inputs = (RAM$inputs$timestamp == RAM$ticks)
	input = paste(RAM$inputs[current_frame_inputs,]$text, collapse = '')
	#if multiple inputs happen on the same frame then they're squished together

	#activate actions
	if (sum(current_frame_inputs) > 0 && input != ''){
		for (key in strsplit(input, '', fixed = TRUE)[[1]]){
			action = RAM$ROM$keybinds[key]
			if (!is.na(action)) RAM$actions[action] = TRUE
		}
	}

	return(RAM)
}



#' Ingame Commands
#'
#' @description
#' Allow the user to interact with the RAM from the listening session by inputting `/[command]` during listening.
#'
#' See `vignette("rrio")` to see these in action.
#'
#' @param RAM [RAM][ram.init] object.
#' @param command Command to use; parsed from `inputs.csv`.
#' @section Commands:
#' ||||
#' |-|-|-|
#' |`/pause`||Pauses the RAM without stopping the gameloop.|
#' ||||
#' |`/resume`||Resumes the game if paused.|
#' ||||
#' |`/tick`||Iterates the RAM one tick, as if `ram.tick()` had been called in the display session.|
#' ||||
#' |`/rollback`|\verb{}|Forces a rollback, and draws if the game is paused.|
#'
#' If the game is paused and an input is entered, it will be processed next `/tick` or when the game resumes. This allows the player to play a game frame-by-frame.
#'
#' @details
#' These commands are generally useful to debugging or testing parts of a game that are difficult to test at full speed. Alternatively, greater control can be achieved by using the display session and manually interacting with the game with:
#'
#' ```
#' RAM = ram.input(RAM, [input])
#' RAM = ram.tick(RAM)
#' render.ram(RAM)
#' ```
#' Which also allows the user to copy and restore RAMs as savestates, etc.
inputs.command = function(RAM, command){
	switch(command,
		"/pause"={
			RAM$paused = TRUE
		},

		"/resume"={
			RAM = ram.resume(RAM)
		},

		"/tick"={
			RAM = ram.tick(RAM)
			render.ram(RAM, clear_console = TRUE)
		},

		"/rollback"={
			RAM = ram.rollback(RAM)
			if (RAM$paused) render.ram(RAM, clear_console = TRUE)
		}
	)

	return(RAM)
}

