library(png)


compress_gif = function(files){ #files: ordered vector of full filenames of each frame

	last_frame = readPNG(files[1])
	files = files[-1]

	data = list(which(last_frame != 0))

	for (filename in files){
		frame = readPNG(filename)

		changes = which(last_frame != frame)

		last_frame = frame

		data = c(data, list(changes))
	}

	return(data)
}


gif_folder = '/Users/gabrielbroussardkorr/Desktop/rgifs/badapple/lores/' #requires trailing slash
bad_apple_files = paste(gif_folder,list.files(gif_folder),sep='')
#bad_apple_files = bad_apple_files[nchar(bad_apple_files) == 74] #first 1000 frames

bad_apple_number = as.integer(substr(bad_apple_files,68,71))
bad_apple_files[bad_apple_number] = bad_apple_files

BadApple.data = compress_gif(bad_apple_files)


bar = bad_apple_resolution = dim(readPNG(bad_apple_files[1]))
BadApple = rom.init(bar[2],bar[1], framerate = 30)

BadApple$startup = function(RAM){
	#assemble sprite

	data = rcade::BadApple.data

	badapple = list(framerate = 30) #60 -> one frame per tick

	badapple$frames = vector('list',length(data)) #initialize list size to avoid sloppy growing
	badapple$frames[[1]] = matrix(0,RAM$ROM$screen.height,RAM$ROM$screen.width) #must fill screen exactly

	#reconstruct frames
	#oops, this skips the first frame. oh well.
	for (i in 2:length(data)){
			flips = data[[i]]

			composite = badapple$frames[[i - 1]]
			composite[flips] = 1 - composite[flips] #invert

			badapple$frames[[i]] = composite
	}

	RAM$ROM$sprites = list(badapple=badapple)

	RAM$objects$badapple = list(spritename='badapple')

	return(RAM)
}

#RAM = ram.init(BadApple); RAM = ram.run(RAM)

usethis::use_data(BadApple, overwrite = TRUE)
usethis::use_data(BadApple.data, overwrite = TRUE)
