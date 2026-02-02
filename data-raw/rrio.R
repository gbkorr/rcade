
#WANT A FLAGPOLE OR SMTH AT THE END
#OR JUST A CASTLE. need a little more pixel art!
#fireworks?

#need to actually do a bit of writing in the RENDER vignette about how we can skip frames easily, but we get flicker. maybe a whole flicker section in the vig talking about it


# ROM ----
SuperRrio = rom.init(
	screen.width = 64, screen.height = 32,
	framerate = 30,
	keybinds = c(a='left',d='right',' '='jump')
)

# Misc Sprites ----


SuperRrio$tilesize = 4

SuperRrio$sprites$ground_tile = render.makesprite('
OOOO
O O

   O
')
SuperRrio$sprites$brick_tile = render.makesprite('
OOOO
O OO
OO O
OOOO
')
SuperRrio$sprites$rock_tile = render.makesprite('
OOOO
 O O
OOOO
O  O
')

# Enemy Sprites ----

# Rrio Sprites ----
SuperRrio$sprites$rrio.idle2 = render.makesprite('
o_o
___
o_o
')
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

# Startup ----

SuperRrio$startup = function(RAM){

	#Rrio
	RAM$objects$rrio = list(
		width = 6/4, #in collision scale
		height = 11/4,

		x = floor(RAM$ROM$screen.width/2), #centered horizontally
		y = floor(RAM$ROM$screen.height/2), #centered vertically

		pos.x = 16,
		pos.y = 4,

		#velocity
		vx = 0.05,
		vy = 0,

		#gravity
		gravity = 0.01,

		spritename = 'rrio.idle'
	)

	#collision
	RAM$objects$collision = list(
		data = render.makesprite('

                  bbbb


             bbbbbb             rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
                                        rr        r       rrr
                                        r         r       rr
         bbbb        bbbb                                  r


oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
',lookup=c(' '=0,o=1,b=2,r=3)),

		draw = function(scene, obj, RAM){
			#MOVE THIS TO ITS OWN FUNCTION (and make draw = that function; much nicer than defining it here)

			pos.x = RAM$objects$rrio$pos.x
			pos.y = RAM$objects$rrio$pos.y

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
	)

	#enemies

	return(RAM)
}


# Physics ----

SuperRrio$move_rrio = function(RAM){
	rrio = RAM$objects$rrio

	#code controlling rrio will be in a function called before this one

	#apply gravity
	rrio$vy = rrio$vy - rrio$gravity

	#code for interacting with collision
	rrio = RAM$ROM$collide(rrio,RAM$objects$collision$data)

	#code to move Rrio
	rrio$pos.x = rrio$pos.x + rrio$vx
	rrio$pos.y = rrio$pos.y + rrio$vy

	RAM$objects$rrio = rrio

	return(RAM)
}
SuperRrio$collide = function(obj,collision){
	obj$grounded = FALSE #set object to airborne; if it's on a surface, it'll be set to grounded later

	#new position of object (after applying velocity)
	#this function checks if this position is valid, and tweaks it if not
	new.x = obj$pos.x + obj$vx
	new.y = obj$pos.y + obj$vy

	#horizontal and vertical span of tiles occupied by obj
	loc.x = ceiling(obj$pos.x):ceiling(obj$pos.x + obj$width)
	loc.y = 1 + nrow(collision) - ceiling(obj$pos.y):ceiling(obj$pos.y - obj$height) #need this subtraction so pos.y agrees with the direction of the collision matrix

	#clip these inbounds; of course you can't collide with collision outside the bounds of the collision
	loc.x = loc.x[loc.x %in% 1:ncol(collision)]
	loc.y = loc.y[loc.y %in% 1:nrow(collision)]

	#if any of these tiles are solid (nonzero in the collision matrix),
	#then the object is inside a tile! A collision must have occurred and we should resolve it
	if (sum(collision[loc.y,loc.x]) > 0){

		#land on ground (bottom face of object's hitbox passes a tile boundary)
		if (ceiling(obj$pos.y - obj$height) != floor(new.y - obj$height)){
			obj$grounded = TRUE
			new.y = ceiling(new.y - obj$height) + obj$height
			obj$vy = 0
		}

		#right wall
		if (floor(obj$pos.x + obj$width) != ceiling(new.x + obj$width)){
			new.x = floor(new.x + obj$width) - obj$width
			#obj$vx = 0
		}


	}

	obj$pos.x = new.x
	obj$pos.y = new.y

	return(obj)
}

# Graphics ----

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

# Custom ----
SuperRrio$custom = function(RAM){
	RAM = RAM$ROM$move_rrio(RAM)

	return(RAM)
}

# ----
