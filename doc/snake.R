## ----include=FALSE------------------------------------------------------------

devtools::load_all(".")

## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----class.source = 'fold-show'-----------------------------------------------
Snake = rom.init(16,8,framerate=2,sprites=list(pixel=matrix(1)))

## ----class.source = 'fold-show'-----------------------------------------------
#Snake$keybinds = c(w = 'up', a = 'left', s = 'down', d = 'right')

## -----------------------------------------------------------------------------
Snake$startup = function(RAM){
  RAM$objects$head = list(
  		x = floor(RAM$ROM$screen.width / 2),
  		y = floor(RAM$ROM$screen.height / 2),
  
  		spritename = 'pixel',
  
  		direction = 'neutral'
  	)
  return(RAM)
}

## -----------------------------------------------------------------------------
Snake$set_direction = function(RAM){
  #name of the actions pressed on this tick, or NULL
  actions = names(RAM$actions)[which(RAM$actions == TRUE)]
  
  #print the direction so we know it's working
  RAM$echo = paste(actions,collapse = ' ') 
  
  #set head direction
  if (length(actions)) RAM$objects$head$direction = actions[[1]] 
  
  return(RAM)
}

## -----------------------------------------------------------------------------
Snake$move_head = function(RAM){
  head = RAM$objects$head #for typing convenience
    
  print(head)
  #convert direction name to x and y
	direction = list(
	  'neutral' = c(0,0),
		'left'= c(-1,0),
		'right' = c(1,0),
		'up' = c(0,-1),
		'down' = c(0,1)
	)[[head$direction]]

	head$x = head$x + direction[1]
	head$y = head$y + direction[2]

	RAM$objects$head = head #push changes
	
	return(RAM)
}

## ----eval=FALSE---------------------------------------------------------------
# Snake = rom.init(16,8,framerate=2,sprites=list(pixel=matrix(1)))
# 
# #define helper functions (see preceding sections)
# Snake$set_direction = function...
# Snake$move_head = function...
# 
# Snake$startup = function(RAM){
#   RAM$objects$head = list(
#   		x = floor(RAM$ROM$screen.width / 2),
#   		y = floor(RAM$ROM$screen.height / 2),
#   		spritename = 'pixel',
#   		direction = 'neutral'
#   	)
#   return(RAM)
# }
# 
# Snake$custom = function(RAM){
#   RAM = RAM$ROM$set_direction(RAM)
# 
#   RAM = RAM$ROM$move_head(RAM)
# 
#   return(RAM)
# }
# 
# RAM = ram.init(Snake) #initialize RAM
# RAM = ram.run(RAM) #run game with RAM

## -----------------------------------------------------------------------------
Snake$make_border = function(RAM){
  #make border sprite
  box = matrix(1,RAM$ROM$screen.height,RAM$ROM$screen.width)
  box[2:(nrow(box) - 1), 2:(ncol(box) - 1)] = 2
  
  #push this sprite to ROM$sprites
  RAM$ROM$sprites$border = box
  
  #make object to display sprite
  RAM$objects$border = list(spritename='border')
 
  return(RAM) 
}

## ----echo=FALSE---------------------------------------------------------------
box = matrix(1,8,16)
box[2:(nrow(box) - 1), 2:(ncol(box) - 1)] = 2
box[4,8] = 1

render.matrix(box)

## -----------------------------------------------------------------------------
Snake$spawn_segment = function(RAM){
  #spawn new tail segment
  RAM = ram.new_object(RAM, list(
  	x = RAM$objects$head$x,
  	y = RAM$objects$head$y,
  
  	#used to find which objects are tail objects
  	is_segment = TRUE, 
  
  	#tick on which this segment spawned
  	time_created = RAM$ticks, 
  
  	spritename = 'pixel'
  ))

  return(RAM)  
}

## -----------------------------------------------------------------------------
Snake$remove_tail = function(RAM){
  oldest_time = Inf
  oldest_index = NULL
  for (i in 1:length(RAM$objects)){
  	obj = RAM$objects[[i]]
  
  	if (!is.null(obj$is_segment)){ #obj has $is_segment property
  		if (obj$time_created < oldest_time){ #object is oldest so far
  			oldest_time = obj$time_created
  			oldest_index = i
  		}
  	}
  }
  #remove oldest segment
  RAM$objects = RAM$objects[-oldest_index] 
  
  return(RAM)
}

## ----eval=FALSE---------------------------------------------------------------
# Snake = rom.init(16,8,framerate=5,sprites=list(pixel=matrix(1)))
# 
# #helper functions from before
# Snake$set_direction = function...
# Snake$move_head = function...
# Snake$make_border = function...
# Snake$spawn_segment = function...
# Snake$remove_tail = function...
# 
# Snake$startup = function(RAM){
#     #make border
#     RAM = RAM$ROM$make_border(RAM)
# 
#     #make head
#     RAM$objects$head = list(
#   		x = floor(RAM$ROM$screen.width / 2),
#   		y = floor(RAM$ROM$screen.height / 2),
#   		spritename = 'pixel',
#   		direction = 'neutral'
#   	)
# 
#     return(RAM)
# }
# 
# Snake$custom = function(RAM){
#   #only do segment stuff once the snake starts moving
#   if (RAM$objects$head$direction != 'neutral'){
#     RAM = RAM$ROM$spawn_segment(RAM)
# 
#     #skip this every fifth tick to grow the snake
#     if (RAM$ticks %% 5 != 0) RAM = RAM$ROM$remove_tail(RAM)
#   }
# 
# 	#move snake
#   RAM = RAM$ROM$set_direction(RAM)
#   RAM = RAM$ROM$move_head(RAM)
# 
#   return(RAM)
# }
# 
# quickload(Snake)

## ----eval=F-------------------------------------------------------------------
# RAM$objects = RAM$objects[oldest_index]

## -----------------------------------------------------------------------------
#returns true if both objects are at the same coordinates
Snake$overlap = function(obj1, obj2){
	if (obj1$x == obj2$x && obj1$y == obj2$y) return(TRUE)
	else return(FALSE)
}

## -----------------------------------------------------------------------------
Snake$check_game_end = function(RAM){
	end_game = FALSE
	
	#out of bounds
	if (
	  RAM$objects$head$x < 2 ||
		RAM$objects$head$x > RAM$ROM$screen.width - 1 ||
		RAM$objects$head$y < 2 ||
		RAM$objects$head$y > RAM$ROM$screen.height - 1
	) end_game = TRUE
	
	#check overlap with segment
	#using the same loop from Snake$remove_segment to iterate over the segments
	for (i in 1:length(RAM$objects)){
			obj = RAM$objects[[i]]
			if (!is.null(obj$is_segment)){
				if (RAM$ROM$overlap(RAM$objects$head, obj)) end_game = TRUE
			}
	}
	
	#stop the game when you lose
	if (end_game) RAM$ROM$end_game(RAM)
	
	return(RAM)
}

Snake$end_game = function(RAM){
		cat('Game over!')
		ram.end() #stops the game
}

## ----eval=F-------------------------------------------------------------------
# RAM$objects$apple = list(
# 	x = sample(2:(RAM$ROM$screen.width - 1),1), #random location
# 	y = sample(2:(RAM$ROM$screen.height - 1),1),
# 
# 	spritename = 'pixel'
# )

## ----eval=F-------------------------------------------------------------------
# if (RAM$ROM$overlap(RAM$objects$head,RAM$objects$apple)){
# 	RAM = RAM$ROM$eat_apple(RAM) #eat apple
# } else {
# 	RAM = RAM$ROM$remove_tail(RAM)
# }

## -----------------------------------------------------------------------------
#moves the apple
Snake$eat_apple = function(RAM){
	valid = FALSE #is the apple in a valid location?
	
	#loop until the apple is in a valid (unoccupied) location
	while (!valid){
		valid = TRUE

		#new random location
		RAM$objects$apple$x = sample(2:(RAM$ROM$screen.width - 1),1)
		RAM$objects$apple$y = sample(2:(RAM$ROM$screen.height - 1),1)

		#overlapping anything? check all the segments again
		for (i in 1:length(RAM$objects)){
			obj = RAM$objects[[i]]
			if (!is.null(obj$is_tail)){
				if (RAM$ROM$overlap(RAM$objects$apple,obj)) { 
					#overlaps something, break out and try again with a new location
					valid = FALSE
					break
				}
			}
		}
	}

	return(RAM)
}

## ----eval=FALSE---------------------------------------------------------------
# Snake = rom.init(16,8,framerate=5,sprites=list(pixel=matrix(1)))
# 
# #helper functions from before
# Snake$set_direction = function...
# Snake$move_head = function...
# Snake$make_border = function...
# Snake$spawn_segment = function...
# Snake$remove_tail = function...
# Snake$eat_apple = function...
# Snake$check_game_end = function...
# Snake$end_game = function...
# 
# Snake$startup = function(RAM){
#     #make border
#     RAM = RAM$ROM$make_border(RAM)
# 
#     #make head
#     RAM$objects$head = list(
#   		x = floor(RAM$ROM$screen.width / 2),
#   		y = floor(RAM$ROM$screen.height / 2),
#   		spritename = 'pixel',
#   		direction = 'neutral'
#   	)
# 
#     #make apple
#     RAM$objects$apple = list(
# 			x = sample(2:(RAM$ROM$screen.width - 1),1), #random location
# 			y = sample(2:(RAM$ROM$screen.height - 1),1),
# 		
# 			spritename = 'pixel'
# 		)
# 
#     return(RAM)
# }
# 
# Snake$custom = function(RAM){
#   #only do segment stuff once the snake starts moving
#   if (RAM$objects$head$direction != 'neutral'){
#     RAM = RAM$ROM$spawn_segment(RAM)
# 
#     #eat apple or remove tail
#     if (RAM$ROM$overlap(RAM$objects$head,RAM$objects$apple)){
# 			RAM$echo = 'Apple Eaten' #print this so we know it works
# 			RAM = RAM$ROM$eat_apple(RAM) #eat apple
# 		} else {
# 			RAM = RAM$ROM$remove_tail(RAM)
# 		}
#   }
# 
# 	#move snake
#   RAM = RAM$ROM$set_direction(RAM)
#   RAM = RAM$ROM$move_head(RAM)
# 
#   #check for game end
#   RAM = RAM$ROM$check_game_end(RAM)
# 
#   return(RAM)
# }
# 
# quickload(Snake)

## -----------------------------------------------------------------------------
Snake$set_direction = function(RAM){
  #name of the actions pressed on this tick, or NULL
  actions = names(RAM$actions)[which(RAM$actions == TRUE)]
  
  #set head direction
  if (length(actions)) {
  	action = actions[[1]]
  	
  	if (action != c( #forbidden direction combos
					neutral = '', #can do any direction from neutral
					left = 'right',
					right = 'left',
					up = 'down',
					down = 'up'
				)[RAM$objects$head$direction]
		){
			RAM$objects$head$direction = action
		}
  }
  
  return(RAM)
}

## -----------------------------------------------------------------------------
Snake$spawn_segment = function(RAM){
	RAM$segments = RAM$segments + 1 #increment segments
	
	#spawn new tail segment
	RAM = ram.new_object(RAM, list(
		x = RAM$objects$head$x,
		y = RAM$objects$head$y,

		#used to find which objects are tail objects
		is_segment = TRUE,

		#tick on which this segment spawned
		time_created = RAM$ticks,

		spritename = 'pixel'
	))

	return(RAM)
}

Snake$remove_tail = function(RAM){
	RAM$segments = RAM$segments - 1 #decrement segments
	
	oldest_time = Inf
	oldest_index = NULL
	for (i in 1:length(RAM$objects)){
		obj = RAM$objects[[i]]

		if (!is.null(obj$is_segment)){ #obj has $is_segment property
			if (obj$time_created < oldest_time){ #object is oldest so far
				oldest_time = obj$time_created
				oldest_index = i
			}
		}
	}
	#remove oldest segment
	RAM$objects = RAM$objects[-oldest_index]

	return(RAM)
}

## ----eval=F, class.source = 'fold-show'---------------------------------------
# RAM$ticks_survived = RAM$ticks_survived + 1

## ----eval=F, class.source = 'fold-show'---------------------------------------
# RAM$segments = 0
# RAM$ticks_survived = 0

## -----------------------------------------------------------------------------
Snake$end_game = function(RAM){
		cat('Game over! Size: ', 
			RAM$segments, 
			'. Time survived: ', 
			RAM$ticks_survived, 
			'.', 
		sep='')
	
		ram.end() #stops the game
}

## ----eval---------------------------------------------------------------------
Snake$eat_apple = function(RAM){
	# check for game win
	if (RAM$segments > (RAM$ROM$screen.width - 2) * (RAM$ROM$screen.height - 2)){
		cat('You win!')
		RAM = RAM$ROM$end_game(RAM)
	}

	valid = FALSE #is the apple in a valid location?

	#loop until the apple is in a valid (unoccupied) location
	while (!valid){
		valid = TRUE

		#new random location
		RAM$objects$apple$x = sample(2:(RAM$ROM$screen.width - 1),1)
		RAM$objects$apple$y = sample(2:(RAM$ROM$screen.height - 1),1)

		#overlapping anything? check all the segments again
		for (i in 1:length(RAM$objects)){
			obj = RAM$objects[[i]]
			if (!is.null(obj$is_tail)){
				if (RAM$ROM$overlap(RAM$objects$apple,obj)) {
					#overlaps something, break out and try again with a new location
					valid = FALSE
					break
				}
			}
		}
	}

	return(RAM)
}

## ----eval=F, class.source = 'fold-show'---------------------------------------
# if (RAM$segments > RAM$starting_segments) RAM = RAM$ROM$remove_tail(RAM)

## -----------------------------------------------------------------------------
Snake$set_difficulty = function(RAM){
	use_defaults = readline('Use default game settings? y/n ')

	if (use_defaults == 'n'){

		desired_framerate = as.integer(readline(paste(
			"How FAST should the game be? ",
			"Input an integer or leave blank for default.",
			"2: Easy",
			"5: Default",
			"10: Hard",
			''
			,sep='\n')))

		desired_width = as.integer(readline(paste(
			"How WIDE should the game area be? ",
			"Input an integer or leave blank for default.",
			"Default: 32",
			''
			,sep='\n')))

		desired_height = as.integer(readline(paste(
			"How TALL should the game area be? ",
			"Input an integer or leave blank for default.",
			"Default: 16",
			''
			,sep='\n')))

		desired_segments = as.integer(readline(paste(
			"How LONG should the snake start at? ",
			"Input an integer or leave blank for default.",
			"Default: 0",
			''
			,sep='\n')))

		#default if blank or nonnumber
		if (!is.na(desired_framerate)) RAM$ROM$framerate = desired_framerate
		if (!is.na(desired_width))  RAM$ROM$screen.width = desired_width
		if (!is.na(desired_height)) RAM$ROM$screen.height = desired_height
		if (!is.na(desired_segments)) RAM$starting_segments = desired_segments

	}

	return(RAM)
}

## ----eval=F-------------------------------------------------------------------
# Snake = rom.init(32,16,framerate=5,sprites=list(pixel=matrix(1)))
# 
# #helper functions from before
# Snake$set_direction = function...
# Snake$move_head = function...
# Snake$make_border = function...
# Snake$spawn_segment = function...
# Snake$remove_tail = function...
# Snake$eat_apple = function...
# Snake$check_game_end = function...
# Snake$end_game = function...
# Snake$set_difficulty = function...
# 
# Snake$startup = function(RAM){
# 	RAM$starting_segments = 10
# 
# 	#set difficulty
# 	RAM = RAM$ROM$set_difficulty(RAM)
# 
# 	#make border
# 	RAM = RAM$ROM$make_border(RAM)
# 
# 	#make head
# 	RAM$objects$head = list(
# 		x = floor(RAM$ROM$screen.width / 2),
# 		y = floor(RAM$ROM$screen.height / 2),
# 		spritename = 'pixel',
# 		direction = 'neutral'
# 	)
# 
# 	#make apple
# 	RAM$objects$apple = list(
# 		x = sample(2:(RAM$ROM$screen.width - 1),1), #random location
# 		y = sample(2:(RAM$ROM$screen.height - 1),1),
# 
# 		spritename = 'pixel'
# 	)
# 
#   RAM$segments = 0
#   RAM$ticks_survived = 0
# 
#   RAM$data = list(x = numeric(0), y = numeric(0), direction = character(0), segments = numeric(0))
# 
#   return(RAM)
# }
# 
# Snake$custom = function(RAM){
#   #only do segment stuff once the snake starts moving
#   if (RAM$objects$head$direction != 'neutral'){
#     RAM = RAM$ROM$spawn_segment(RAM)
# 
#     RAM$ticks_survived = RAM$ticks_survived + 1
# 
#     #eat apple or remove tail
#     if (RAM$ROM$overlap(RAM$objects$head,RAM$objects$apple)){
# 			RAM = RAM$ROM$eat_apple(RAM) #eat apple
# 		}
#     else if (RAM$segments > RAM$starting_segments) {
# 			RAM = RAM$ROM$remove_tail(RAM)
# 		}
# 			#once the starting number of segments has been reached, start removing the tail
#   }
# 
# 	#move snake
#   RAM = RAM$ROM$set_direction(RAM)
#   RAM = RAM$ROM$move_head(RAM)
# 
#   #check for game end
#   RAM = RAM$ROM$check_game_end(RAM)
# 
#   return(RAM)
# }
# 
# 
# quickload(Snake)

## ----eval=F-------------------------------------------------------------------
# RAM$data = list(x = numeric(0), y = numeric(0), direction = character(0), segments = numeric(0))

## ----eval=F-------------------------------------------------------------------
# Snake$record_data = function(RAM){
# 	#position
# 	RAM$data$x = c(RAM$data$x, RAM$objects$head$x)
# 	RAM$data$y = c(RAM$data$y, RAM$objects$head$y)
# 	#direction
# 	RAM$data$direction = c(RAM$data$direction, RAM$objects$head$direction)
# 	#segments
# 	RAM$data$segments = c(RAM$data$segments, RAM$segments)
# 	
# 	return(RAM)	
# }

## ----eval=F-------------------------------------------------------------------
# Snake$view_data = function(RAM){
# 	if (readline("View graphs? y/n ") != 'y') return()
# 	
# 	op = par(mfrow = c(1,1), mar = c(5, 4, 4, 2) + 0.1)
# 	par(mfrow=c(2,2), mar = c(4,4,3,2) + 0.1)
# 	
# 	data = RAM$data
# 	
# 	#plot 1: segments over time
# 	plot(data$segments,type='l',xlab='Time',ylab='Segments',main='Snake Length')
# 	
# 	#plot 2: direction frequency
# 	barplot(table(data$direction),xlab='Facing Direction',ylab='Frequency',main='Favored Directions')
# 	
# 	#plot 3: handedness preference
# 	handedness = list(
# 		right = c(up='Left',down='Right'),
# 		left = c(down='Left',up='Right'),
# 		up = c(left='Left',right='Right'),
# 		down = c(right='Left',left='Right')
# 	)
# 	hand_direction = c() #handedness direction of each turn (or NA if no turn)
# 	for (d in 1:(length(data$direction) - 1)) hand_direction = c(hand_direction,handedness[[data$direction[d]]][data$direction[d + 1]])
# 	hand_table = data.frame("direction" = data$direction[1:(length(data$direction)-1)], "turn" = hand_direction)
# 	barplot(t(table(hand_table)), beside=TRUE, main = 'Turning Handedness\nPreference', xlab = 'Facing Direction', ylab = 'Frequency')
# 	legend('bottomleft', title= '\nTurn\nDirection', legend=c('Left','Right'), fill=gray.colors(2))
# 	
# 	#plot 4: tile frequency
# 	tile_heatmap = matrix(0,RAM$ROM$screen.height,RAM$ROM$screen.width)
# 	#using x and y position for each tick, get position frequencies
# 	for (tick in 1:length(data$x)){
# 			tile_heatmap[data$y[tick],data$x[tick]] = tile_heatmap[data$y[tick],data$x[tick]] + 1
# 	}
# 	tile_heatmap = tile_heatmap[2:(nrow(tile_heatmap)-1), 2:(ncol(tile_heatmap)-1)] #clip out the border
# 	tile_heatmap = tile_heatmap[nrow(tile_heatmap):1,] #flip upside-down to match the way the game is drawn
# 	image(1:ncol(tile_heatmap), 1:nrow(tile_heatmap), t(tile_heatmap),xlab='',ylab='',xaxt='n', yaxt='n', main= 'Tile Frequency')
# 	
# 	par(op) #restore original settings
# }

## ----echo=F, fig.width=6, fig.height=5----------------------------------------
#----
data = data = list(x = c(9, 10, 10, 10, 9, 8, 7, 7, 7, 7, 8, 9, 9, 10, 11, 
11, 10, 9, 8, 7, 6, 5, 4, 4, 4, 4, 5, 6, 7, 7, 6, 5, 4, 4, 4, 
5, 6, 7, 7, 7, 6, 5, 4, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 5, 6, 
7, 8, 9, 9, 9, 8, 7, 6, 5, 5, 6, 7, 8, 8, 9, 10, 11, 11, 11, 
12, 13, 14, 14, 14, 13, 12, 12, 11, 10, 10, 10, 10, 11, 12, 13, 
14, 14, 14, 13, 12, 12, 11, 10, 10, 10, 11, 12, 13, 14, 15, 15, 
14, 13, 12, 11, 10, 10, 10, 10, 11, 11, 10, 9, 8, 7, 6, 5, 5, 
5, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 3, 4, 5, 5, 5, 6, 7, 8, 
9, 10, 11, 12, 13, 13, 12, 11, 10, 9, 8, 7, 6, 5, 5, 6, 7, 8, 
9, 10, 11, 11, 10, 9, 8, 7, 6, 6, 7, 8, 9, 10, 11, 12, 13, 14, 
14, 14, 14, 14, 13, 12, 11, 10, 9, 9, 8, 7, 7, 8, 9, 10, 10, 
10, 9, 8, 7, 6, 5, 5, 5, 4, 4, 4, 4, 5, 6, 7, 8, 9, 10, 11, 11, 
11, 10, 9, 8, 8, 8, 9, 10, 11, 12, 13, 13, 13, 13, 13, 14, 14, 
14, 14, 14, 14, 13, 12, 11, 10, 9, 8, 8, 8, 8, 7, 6, 5, 5, 6, 
7, 8, 9, 10, 11, 12, 12, 12, 12, 12, 11, 10, 9, 8, 7, 7, 7), 
    y = c(4, 4, 5, 6, 6, 6, 6, 5, 4, 3, 3, 3, 4, 4, 4, 3, 3, 
    3, 3, 3, 3, 3, 3, 4, 5, 6, 6, 6, 6, 5, 5, 5, 5, 6, 7, 7, 
    7, 7, 6, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 4, 
    4, 4, 4, 4, 3, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 3, 
    2, 2, 2, 2, 3, 4, 4, 4, 5, 5, 5, 4, 3, 2, 2, 2, 2, 2, 3, 
    4, 4, 4, 5, 5, 5, 4, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 
    3, 4, 5, 5, 6, 6, 6, 6, 6, 6, 6, 5, 4, 3, 3, 3, 3, 3, 2, 
    2, 2, 2, 2, 2, 2, 3, 3, 3, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 
    4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 5, 6, 7, 7, 7, 7, 
    7, 7, 6, 6, 6, 5, 5, 5, 5, 4, 3, 3, 3, 3, 3, 3, 4, 5, 5, 
    4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 4, 4, 4, 4, 5, 6, 6, 6, 
    6, 6, 6, 5, 4, 3, 2, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7, 7, 
    6, 5, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 4, 5, 6, 7, 7, 
    7, 7, 7, 7, 6, 5), direction = c("right", "right", "down", 
    "down", "left", "left", "left", "up", "up", "up", "right", 
    "right", "down", "right", "right", "up", "left", "left", 
    "left", "left", "left", "left", "left", "down", "down", "down", 
    "right", "right", "right", "up", "left", "left", "left", 
    "down", "down", "right", "right", "right", "up", "up", "left", 
    "left", "left", "up", "right", "right", "right", "right", 
    "right", "up", "left", "left", "left", "left", "down", "right", 
    "right", "right", "right", "up", "up", "left", "left", "left", 
    "left", "down", "right", "right", "right", "down", "right", 
    "right", "right", "up", "up", "right", "right", "right", 
    "down", "down", "left", "left", "down", "left", "left", "up", 
    "up", "up", "right", "right", "right", "right", "down", "down", 
    "left", "left", "down", "left", "left", "up", "up", "right", 
    "right", "right", "right", "right", "up", "left", "left", 
    "left", "left", "left", "down", "down", "down", "right", 
    "down", "left", "left", "left", "left", "left", "left", "up", 
    "up", "up", "right", "right", "right", "right", "up", "left", 
    "left", "left", "left", "left", "left", "down", "right", 
    "right", "down", "down", "right", "right", "right", "right", 
    "right", "right", "right", "right", "down", "left", "left", 
    "left", "left", "left", "left", "left", "left", "up", "right", 
    "right", "right", "right", "right", "right", "up", "left", 
    "left", "left", "left", "left", "up", "right", "right", "right", 
    "right", "right", "right", "right", "right", "down", "down", 
    "down", "down", "left", "left", "left", "left", "left", "up", 
    "left", "left", "up", "right", "right", "right", "up", "up", 
    "left", "left", "left", "left", "left", "down", "down", "left", 
    "up", "up", "up", "right", "right", "right", "right", "right", 
    "right", "right", "down", "down", "left", "left", "left", 
    "down", "down", "right", "right", "right", "right", "right", 
    "up", "up", "up", "up", "right", "down", "down", "down", 
    "down", "down", "left", "left", "left", "left", "left", "left", 
    "up", "up", "up", "left", "left", "left", "up", "right", 
    "right", "right", "right", "right", "right", "right", "down", 
    "down", "down", "down", "left", "left", "left", "left", "left", 
    "up", "up"), segments = c(0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 
    3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 
    5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 
    7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 
    7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 
    7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 
    9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 
    11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 
    12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 
    13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 
    14, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 16, 16, 16, 
    16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 
    17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 
    18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 
    18, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 19, 19, 19, 19, 
    19, 19, 19, 19, 19, 19, 19, 19, 19, 20))
#----

	#copied sloppily from Snake$view_data

	par(mfrow=c(2,2), mar = c(4,4,3,2) + 0.1)
	
	#plot 1: segments over time
	plot(data$segments,type='l',xlab='Time',ylab='Segments',main='Snake Length')
	
	#plot 2: direction frequency
	barplot(table(data$direction),xlab='Facing Direction',ylab='Frequency',main='Favored Directions')
	
	#plot 3: handedness preference
	handedness = list(
		right = c(up='Left',down='Right'),
		left = c(down='Left',up='Right'),
		up = c(left='Left',right='Right'),
		down = c(right='Left',left='Right')
	)
	hand_direction = c() #handedness direction of each turn (or NA if no turn)
	for (d in 1:(length(data$direction) - 1)) hand_direction = c(hand_direction,handedness[[data$direction[d]]][data$direction[d + 1]])
	hand_table = data.frame("direction" = data$direction[1:(length(data$direction)-1)], "turn" = hand_direction)
	barplot(t(table(hand_table)), beside=TRUE, main = 'Turning Handedness\nPreference', xlab = 'Facing Direction', ylab = 'Frequency')
	legend('bottomleft', title= '\nTurn\nDirection', legend=c('Left','Right'), fill=gray.colors(2),cex=0.8)
	
	#plot 4: tile frequency
	tile_heatmap = matrix(0,8,16)
	#using x and y position for each tick, get position frequencies
	for (tick in 1:length(data$x)){
			tile_heatmap[data$y[tick],data$x[tick]] = tile_heatmap[data$y[tick],data$x[tick]] + 1
	}
	tile_heatmap = tile_heatmap[2:(nrow(tile_heatmap)-1), 2:(ncol(tile_heatmap)-1)] #clip out the border
	tile_heatmap = tile_heatmap[nrow(tile_heatmap):1,] #flip upside-down to match the way the game is drawn
	image(1:ncol(tile_heatmap), 1:nrow(tile_heatmap), t(tile_heatmap),xlab='',ylab='',xaxt='n', yaxt='n', main= 'Tile Frequency')

