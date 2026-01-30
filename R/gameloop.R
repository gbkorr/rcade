

#somewhere, we have to talk about how to interact with an initialized game:
# ram.run() to run it live, or ram.tick() to run a single tick (inputs must be set manually, e.g. with RAM$actions['jump'] == 'pressed'



#' Play a Game
#'
#' Starts a game immediately using a ROM.
#' @details
#' Convenience wrapper for the code:
#' ```
#' RAM = ram.init(ROM)
#' RAM = ram.run(RAM)
#' ```
#' This saves RAM in the environment in which `quickload()` was called, so the RAM can be accessed afterwards as if it were run manually.
#' @param ROM [ROM][rom.init] to play.
#' @examples
#' quickload(Snake)
quickload = function(ROM){
	#assign variables in the environment quickload was called in
	assign('RAM', ram.init(ROM), envir = parent.frame())
	assign('RAM', ram.run(get('RAM', envir = parent.frame())), envir = parent.frame())
	#this get() call isn't necessary, but CRAN doesn't like the simpler version
}



#' Main Gameloop
#'
#' @description
#' `ram.run()` runs the main gameloop, continuously ticking and drawing.
#'
#' The game can be paused with `^C`, and will resume when `ram.run()` is called again.
#' @details
#' This function runs the following code and returns the RAM upon interruption by ^C or error.
#' ```
#' while(TRUE) RAM = ram.update(RAM)
#'
#' ```
#' The function will also print a full traceback if it encounters an error.
#' @param RAM [RAM](ram.init) object to run.
#' @param start_at RAM will wait until [time.sec()]`==` this value to start running. If `NULL`, RAM starts running immediately. This argument is used to sync multiplayer sessions and otherwise doesn't matter.
#' @section Function Tree:
#' Functions are nested in the gameloop like so:
#'
#' [ram.run()]\cr
#' \verb{	}[ram.update()] every frame (see `vignette("timing")`)\cr
#' \verb{		}[inputs.get()]\cr
#' \verb{			}[inputs.read()]\cr
#' \verb{			}[inputs.command()] if any commands are sent\cr
#' \verb{			}[ram.rollback()] if any inputs were received late\cr
#' \verb{		}[inputs.process()]\cr
#' \verb{		}[ram.tick()]\cr
#' \verb{			}`RAM$ROM$custom()`\cr
#' \verb{		}[render.ram()] if `RAM$time > `[time.sec()]\cr
#' \verb{			}[render.object()] for every object in `RAM$objects`\cr
#' \verb{				}[render.animate()] if the object has a [complex sprite][render.animate]\cr
#' \verb{				}[render.sprite()] or custom `obj$draw()`\cr
#' \verb{					}[render.overlay()]\cr
#' \verb{			}[render.scene()]\cr
#' \verb{				}[render.overlay()] for every layer in `scene$layers`\cr
#' \verb{			}[render.matrix()]
ram.run = function(RAM, start_at = NULL){
	RAM = ram.resume(RAM, start_at)

	RAM$intermediate = ram.backup(RAM)
	RAM$backup = RAM$intermediate

	tryCatch({
			gamestack = evaluate::try_capture_stack({
				while(TRUE) {
					RAM = ram.update(RAM) #loop game infinitely.
				}
			},env=environment())

			#this code is only run if the process encounters an error
			if (gamestack$message != 'end'){ #intentional exiting is done via `stop('end')`

				message('Traceback:')
				print(gamestack$calls)

				message('Call:')
				print(gamestack$call)

				cat('\n')
				message(paste('Error:\n',gamestack$message,sep=''))

				cat('\nSee ?rom.help for common issues.')
			}

			return(RAM)
	},
		interrupt = function(void){cat('Paused: tick ', RAM$ticks,sep=''); return(RAM)} #return on ^C
	)
}


#' Gameloop
#'
#' Ticks RAM, draws RAM, and syncs time with the framerate.\cr This function is looped infinitely by [ram.run()]; it should not be used alone.
#'
#' @details
#' If the RAM is behind the current frame (lagging) (`RAM%time < `[time.sec()]):
#' * drawing is skipped
#' * `ram.update()` is called again with no delay
#'
#' If the RAM is ahead of the current frame (caught up):
#' * [render.ram()] is called to draw the game
#' * the game sleeps until the next frame
#'
#' This tries to keep the RAM on the current frame, such that it will always be ahead (and have time to draw).\cr
#' When the RAM is behind the current frame, the game update process speeds up and runs the game as fast as possible without any drawing to get it back to the current time.\cr
#'
#' Since drawing is by far the slowest part of the gameloop, this allows it to recover and catch up to the present very quickly after time is rewound in a [rollback][ram.rollback].
#' @param RAM [RAM](ram.init) object to update.
ram.update = function(RAM){
	ahead = time.ram(RAM)
	if (ahead > 0) Sys.sleep(ahead) #wait to the end of the current frame, if ahead

	RAM$debug$time = c(RAM$debug$time, time.sec()) #time at the start of each tick

		time.debug = time.sec()
	RAM = inputs.get(RAM)
	RAM = inputs.process(RAM)
		RAM$debug$time.inputs = c(RAM$debug$time.input, time.sec() - time.debug)

		time.debug = time.sec()
	if (!RAM$paused) RAM = ram.tick(RAM) #run a frame
		RAM$debug$time.tick = c(RAM$debug$time.tick, time.sec() - time.debug) #unfortunately this is the nicest (+lightest) way to do this; other methods slow things down

	if (time.ram(RAM) > 0) { #if still ahead, draw and wait. ahead = RAM has time to draw
			time.debug = time.sec()
		render.ram(RAM, clear_console = TRUE)
			RAM$debug$time.draw = c(RAM$debug$time.draw, time.sec() - time.debug)
			RAM$debug$frames.drawn = c(RAM$debug$frames.drawn, RAM$ticks)
	} else RAM$debug$time.draw = c(RAM$debug$time.draw, NA)

		RAM$debug$frames = c(RAM$debug$frames, RAM$ticks)

		RAM$debug$ahead = c(RAM$debug$ahead, time.ram(RAM)) #record this value

	return(RAM)
} #this one you don't want to call independently


#' Tickstep RAM
#'
#' Runs one tick (frame) of the RAM.
#' This means calling `RAM$ROM$custom()` once (see [rom.init]).
#' @param RAM [RAM](ram.init) object to update.
#' @returns
#' The following happens to the RAM object:
#' * `RAM$ticks` increases by one.\cr (a new tick has occurred)
#' * `RAM$time` increases by 1/framerate.\cr (the RAM is now one frame further in time)
#' * `RAM = RAM$ROM$custom(RAM)` is run.\cr (the game code is run once on the RAM)\cr
#' * `RAM$backup` is occasionally updated; see [ram.rollback].\cr (the game is occasionally backed up)
ram.tick = function(RAM){
	global_RNG = .Random.seed #back up actual RNG seed to restore at the end of function to comply with "leave no trace"
	.Random.seed <<- RAM$rng #set RNG to RAM rng

	RAM = RAM$ROM$custom(RAM)
	if(is.null(RAM)) stop("RAM empty; did you forget to return(RAM) somewhere?")

	RAM$rng = .Random.seed #update RAM rng
	.Random.seed <<- global_RNG #restore original RNG

	RAM$ticks = RAM$ticks + 1
	RAM$time = RAM$time + 1/RAM$ROM$framerate


	#push backups
	if (RAM$ticks %% floor(RAM$ROM$framerate * RAM$ROM$backup_duration / 2) == 0) {
		RAM$backup = RAM$intermediate
		RAM$intermediate = ram.backup(RAM)
	}

	return(RAM)
}



#' Execute a Rollback
#'
#' @description
#' Restores the RAM state from several seconds ago. [ram.update()] will then rapidly advance the game to catch up with the current time.
#'
#' This is usually triggered by [inputs.read()] upon registering an input that was supposed to have happened, but didn't because it was received late. To prevent the input from being dropped, the game rolls back and reruns the past few seconds to rectify the mistake.
#' @section Backups:
#' RAM always keeps a backup of itself saved in RAM$backup, containing the entire RAM from the time of the backup minus inputs, debug info, and the ROM; these are never rolled back.
#'
#' Backups have a minimum age of `RAM$ROM$backup_duration`; the RAM can only be restored to around that time ago. Backups are saved during [ram.tick()].
#'
#' RAM$intermediate is used to store the next backup before it replaces the current one, to ensure that backups are never younger than `RAM$ROM$backup_duration`.
#'
#' @section Rollback:
#' This function just restores RAM$backup with
#' ```
#' RAM = utils::modifyList(RAM, RAM$backup)
#' ```
#'
#' Since this puts RAM$time behind, the gameloop automatically speeds up to catch the RAM back up.
#'
#' This catchup process runs the inputs again, so if any inputs were received late, they will now be registered on time.
#' @param RAM [RAM](ram.init) object.
ram.rollback = function(RAM){
	RAM$debug$rollback.time = c(RAM$debug$rollback.time, time.sec()) #record a timestamp of when this rollback occurred
	RAM$debug$rollback.ticks = c(RAM$debug$rollback.ticks, RAM$ticks)

	RAM$objects = RAM$backup$objects #manually restore objects, since some may exist that weren't in the backup and won't get cleared
	RAM = utils::modifyList(RAM, RAM$backup)  #this tiny line of code is all it takes for a rollback!
	RAM$intermediate = RAM$backup #clear intermediate

	return(RAM)
}


