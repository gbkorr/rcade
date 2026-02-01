
# ROM ----
SuperRrio = rom.init(
	screen.width = 64, screen.height = 32,
	framerate = 60,
	keybinds = c(a='left',d='right',' '='jump')
)

# Sprites ----

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

# Startup ----

SuperRrio$startup = function(RAM){

	#Rrio
	RAM$objects$rrio = list(
		x = floor(RAM$ROM$screen.width/2), #centered horizontally
		y = floor(RAM$ROM$screen.height/2), #centered vertically

		pos.x = 0,
		pos.y = 5,

		#velocity
		vx = 0,#0.16,
		vy = 0.02,#2,

		#gravity
		gravity = 0*9.8/60/2, #earth gravity / 60fps / 2 units per meter

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
			pos.x = RAM$objects$rrio$pos.x
			pos.y = RAM$objects$rrio$pos.y

			collision = RAM$objects$collision$data


			screen_width_converted = ceiling(RAM$ROM$screen.width / RAM$ROM$tilesize) #screen width in units of collision matrix
			screen_height_converted = ceiling(RAM$ROM$screen.height / RAM$ROM$tilesize)

			#range of columns in the collision matrix that should be onscreen
			xrange = (1:ceiling(RAM$ROM$screen.width / RAM$ROM$tilesize)) +
				floor(pos.x) +
				8#floor(screen_width_converted/2) #horizontal centering

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


# Other ----

SuperRrio$assemble_collision_sprite = function(RAM, xrange, yrange){ #xrange and yrange in the collision matrix; not in pixels
	M = RAM$objects$collision$data #collision matrix

	clipped_xrange = xrange[xrange %in% (1:ncol(M))]
	clipped_yrange = yrange[yrange %in% (1:nrow(M))]


	A = matrix(0,length(yrange),length(xrange))

	A[clipped_yrange - min(yrange) + 1, clipped_xrange - min(xrange) + 1] = M[clipped_yrange, clipped_xrange, drop=FALSE]

	M = A

	warning('rewrite and document this function. it works greaet now!')

	ts = RAM$ROM$tilesize #= 4
	#tilesize; this makes it easier to upgrade the graphics later if we wanted

	sprite = matrix(0,nrow=ts*nrow(M),ncol=ts*ncol(M)) #the sprite will be 4x the size, since each tile is 4x4 pixels

	for (y in 1:nrow(M)) for (x in 1:ncol(M)){
		tile = M[y,x]

		if (tile != 0){ #nonempty sprite
			sprite[ts*y + (1 - 1:(ts)), ts*x + (1 - 1:(ts))] = RAM$ROM$sprites[[ #lookup sprite corresponding to tile and paste it in
				c(
					'ground_tile',
					'brick_tile',
					'rock_tile'
				)[tile]
			]][ts:1,ts:1] #mirror twice because reasons
		}

	}

	return(sprite)
}
SuperRrio$move_rrio = function(RAM){
	rrio = RAM$objects$rrio

	#code controlling rrio will be in a function called before this one

	#apply gravity
	RAM$objects$rrio$vy = rrio$vy - rrio$gravity

	#code for interacting with collision

	#code to move Rrio
	RAM$objects$rrio$pos.x = rrio$pos.x + rrio$vx
	RAM$objects$rrio$pos.y = rrio$pos.y + rrio$vy

	return(RAM)
}


# Custom ----
SuperRrio$custom = function(RAM){
	RAM = RAM$ROM$move_rrio(RAM)

	return(RAM)
}

# ----
