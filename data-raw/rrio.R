
#not finished yet!


# ---- ROM ----
SuperRrio = rom.init(
	screen.width = 64, screen.height = 32,
	framerate = 30,
	keybinds = c(a='left',d='right',' '='jump')
)


# ---- Misc Sprites ----


SuperRrio$tilesize = 4

SuperRrio$sprites$ground_tile = render.makesprite('
OOOO
O O

   O
')
SuperRrio$sprites$brick_tile = render.makesprite('
OOOO
O  O
O  O
OOOO
')
SuperRrio$sprites$rock_tile = render.makesprite('
OOOO
OOOO
OOOO
OOOO
')

# ---- Enemy Sprites ----

# ---- Rrio Sprites ----
SuperRrio$sprites$rrio.idle = render.makesprite('
  oo
o oo o
oooooo
  o o

 ooo
o o o
  o
  o
 o o
 o o
')


# ---- Startup ----

SuperRrio$startup = function(RAM){

	#Rrio
	RAM$objects$rrio = list(
		width = 6/4, #in collision scale; width of sprite
		height = 1.8, #not as tall as the sprite!

		offset.y = -4 * (11/4 - 1.8), #height of sprite - height of bounding box, scaled to collision scale: offsets so the bottom of the sprite matches the bottom of the bounding box

		x = floor(RAM$ROM$screen.width/2), #centered horizontally
		y = floor(RAM$ROM$screen.height/2), #centered vertically

		pos.x = 6,
		pos.y = 4,
		visual_y = 4, #only updated when grounded; used for screen scrolling

		#velocity
		vx = 0,
		vy = 0,

		#details
		gravity = 0.04,
		speed = 0.2,
		jump_strength = 0.6,
		friction = 0.02,

		#properties
		grounded = FALSE,

		spritename = 'rrio.idle' #replace with ram.draw = RAM$ROM$render.rrio
	)

	#collision
	RAM$objects$collision = list(
		draw = RAM$ROM$render.collision,
		data = render.makesprite('



                rr
                rrrr
         bbbb   rrrr         bbbbbbb
                rrrrrr
                rrrrrr
oooooooooooooooorrrrrrrrooooooooo   ooooooooooooooooooooooooooooooo
oooooooooooooooorrrrrrrrooooooooo   ooooooooooooooooooooooooooooooo
',lookup=c(' '=0,o=1,b=2,r=3))
	)

	#enemies

	return(RAM)
}




# ---- Collision Rendering ----
SuperRrio$render.collision = function(scene, obj, RAM){
	pos.x = RAM$objects$rrio$pos.x
	pos.y = RAM$objects$rrio$visual_y

	collision = RAM$objects$collision$data

	screen_width_converted = ceiling(RAM$ROM$screen.width / RAM$ROM$tilesize) #screen width in units of collision matrix
	screen_height_converted = ceiling(RAM$ROM$screen.height / RAM$ROM$tilesize)

	#range of columns in the collision matrix that should be onscreen
	xrange = (1:ceiling(RAM$ROM$screen.width / RAM$ROM$tilesize)) +
		floor(pos.x) - #x pos
		floor(screen_width_converted/2) #horizontal centering

	yrange = 1:screen_height_converted + #onscreen range
		nrow(collision) -  #start at the top of collision instead of bottom
		floor(pos.y) - #y pos
		floor(screen_height_converted/2) #vertical centering

	#sub-collision tile pixel position, so that the scroll can be smooth rather than only by collision tile
	remainder.x = floor(RAM$ROM$tilesize * (pos.x - floor(pos.x)))
	remainder.y = floor(RAM$ROM$tilesize * (pos.y - floor(pos.y)))

	sprite = RAM$ROM$assemble_collision_sprite(RAM,xrange,yrange)
	scene = render.sprite(scene, sprite, x=-remainder.x, y=remainder.y, layer=2) #background layer B
	return(scene)
}

SuperRrio$assemble_collision_sprite = function(RAM, xrange, yrange){ #xrange and yrange in the collision matrix; not in pixels
	M = RAM$objects$collision$data #collision matrix

	#xrange: onscreen values of collision (can be negative)

	#only get values that are valid within collision
	clipped_xrange = xrange[xrange %in% (1:ncol(M))]
	clipped_yrange = yrange[yrange %in% (1:nrow(M))]

	#pad the rest of the value with 0s
	clipped = M[clipped_yrange, clipped_xrange, drop=FALSE]
	M = matrix(0,length(yrange),length(xrange))
	M[clipped_yrange - min(yrange) + 1, clipped_xrange - min(xrange) + 1] = clipped


	#get tilesize for converting collision units to pixels
	ts = RAM$ROM$tilesize #= 4

	sprite = matrix(0,nrow=ts*nrow(M),ncol=ts*ncol(M)) #the sprite will be 4x the size, since each tile is 4x4 pixels

	#check every entry in the onscreen part of the collision matrix and stitch the appropriate sprite into the sprite matrix
	for (y in 1:nrow(M)) for (x in 1:ncol(M)){
		tile = M[y,x]

		if (tile != 0){ #nonempty tile; otherwise the sprite stays transparent
			sprite[ts*y + (1 - 1:(ts)), ts*x + (1 - 1:(ts))] = RAM$ROM$sprites[[ #lookup sprite corresponding to tile and paste it in
				c(
					'ground_tile',
					'brick_tile',
					'rock_tile'
				)[tile]
			]][ts:1,ts:1] #flip twice because ???
		}

	}

	return(sprite)
}

SuperRrio$vertical_scroll = function(RAM){
	rrio = RAM$objects$rrio

	#match screenscroll
	rrio$y = floor(RAM$ROM$screen.height/2) + floor(RAM$ROM$tilesize * (rrio$visual_y - rrio$pos.y))

	#scroll screen vertically if grounded and far enough
	scroll_diff = rrio$visual_y - rrio$pos.y #in collision tiles
	if (rrio$grounded){
		rrio$visual_y	= rrio$visual_y - 0.1 * scroll_diff
		if (abs(scroll_diff) < 0.5) rrio$visual_y = rrio$pos.y
	}

	RAM$objects$rrio = rrio

	return(RAM)
}
# ---- Rrio Control ----
SuperRrio$control_rrio = function(RAM){
	rrio = RAM$objects$rrio

	#can only control movement while grounded
	if (rrio$grounded){
		if (RAM$actions$right) rrio$vx = rrio$speed #regular move; can jump and move on the same tick
		else if (RAM$actions$left) rrio$vx = -rrio$speed
		else {
			#apply friction
			if (abs(rrio$vx) - rrio$friction > 0) rrio$vx = rrio$vx - sign(rrio$vx) * rrio$friction
			else rrio$vx = 0
		}

		#jump/slowwalk
		if (RAM$actions$jump) rrio$vy = rrio$jump_strength
		else if (RAM$actions$right == 1) rrio$vx = 2 * rrio$speed #dash, but can't dash and jump
		else if (RAM$actions$left == 1) rrio$vx = -2 * rrio$speed
	}

	RAM$objects$rrio = rrio

	return(RAM)
}

# ---- Physics ----
SuperRrio$move_object = function(obj,collision){
	#apply gravity
	obj$vy = obj$vy - obj$gravity

	#code for interacting with collision
	obj = RAM$ROM$collide(obj,collision)

	#code to move Rrio
	obj$pos.x = obj$pos.x + obj$vx
	obj$pos.y = obj$pos.y + obj$vy

	return(obj)
}

SuperRrio$collide = function(obj,collision){
	obj$grounded = FALSE #set object to airborne; if it's on a surface, it'll be set to grounded later

	# ---- Vertical Collision ----
	#check and resolve vertical collisions first, then horizontal

	new.x = obj$pos.x + obj$vx
	new.y = obj$pos.y + obj$vy

	#horizontal and vertical span of tiles overlapped by obj bounding box
	loc.x = ceiling(new.x):ceiling(new.x + obj$width)
	loc.y = 1 + nrow(collision) - ceiling(new.y):ceiling(new.y - obj$height)

	#clip inbounds
	loc.x = loc.x[loc.x %in% 1:ncol(collision)]
	loc.y = loc.y[loc.y %in% 1:nrow(collision)]

	#are any of these tiles solid? if so, the bounding box is overlapping collision and a collision has occurred.
	if (sum(collision[loc.y,loc.x]) > 0){

		#land on ground: bottom of bounding box passes gridline
		if (ceiling(obj$pos.y - obj$height) > ceiling(new.y - obj$height)){
			obj$grounded = TRUE #landed on the ground, so become grounded
			obj$pos.y = 0.001 + ceiling(new.y - obj$height) + obj$height #snap to ground
			obj$vy = 0 #stop moving vertically
		}

		#hit ceiling
		else if (ceiling(obj$pos.y) < ceiling(new.y)){
			obj$pos.y = floor(new.y) #snap to ceiling
			obj$vy = 0 #stop moving vertically
		}
	}


	# ---- Horizontal Collision ----
	#repeat this for horizontal collisions now that vertical has been resolved
	#otherwise, you'd constantly collide with tiles while walking on flat ground

	new.x = obj$pos.x + obj$vx
	new.y = obj$pos.y + obj$vy

	#horizontal and vertical span of tiles overlapped by obj bounding box
	loc.x = ceiling(new.x):ceiling(new.x + obj$width)
	loc.y = 1 + nrow(collision) - ceiling(new.y):ceiling(new.y - obj$height)

	#clip inbounds
	loc.x = loc.x[loc.x %in% 1:ncol(collision)]
	loc.y = loc.y[loc.y %in% 1:nrow(collision)]

	#are any of these tiles solid? if so, the bounding box is overlapping collision and a collision has occurred.
	if (sum(collision[loc.y,loc.x]) > 0){

		#right wall
		if (ceiling(obj$pos.x + obj$width) > floor(new.x + obj$width)){
			obj$pos.x = floor(new.x + obj$width) - obj$width #snap to wall
			obj$vx = 0 #stop moving horizontally
		}

		#left wall
		else if (floor(obj$pos.x) < ceiling(new.x)){
			obj$pos.x = 0.01 + ceiling(new.x) #snap to wall
			obj$vx = 0 #stop moving horizontally
		}
	}


	# ----
	return(obj)
}





# ---- Custom ----
SuperRrio$custom = function(RAM){
	#debug check state
	#RAM$echo = paste(RAM$objects$rrio$pos.x,RAM$objects$rrio$pos.y,RAM$objects$rrio$vx,RAM$objects$rrio$vy)

	#control and move rrio
	RAM = RAM$ROM$control_rrio(RAM)
	RAM$objects$rrio = RAM$ROM$move_object(RAM$objects$rrio,RAM$objects$collision$data)

	#vertical screenscroll
	RAM = RAM$ROM$vertical_scroll(RAM)

	#move enemies

	#process gamestate
	#death to enemy/stage, flagpole, etc.

	return(RAM)
}

# ----
#quickload(SuperRrio)
#usethis::use_data(SuperRrio, overwrite = TRUE)
