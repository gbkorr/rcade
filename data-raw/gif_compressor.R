library(png)

#by frame
compress_gif = function(folder.path){
	files = list.files(folder.path)


	last_frame = readPNG(paste(folder.path, files[1], sep='/'))
	files = files[-1]

	data = list(which(last_frame != 0))

	for (filename in files){
		frame = readPNG(paste(folder.path, filename, sep='/'))

		changes = which(last_frame != frame)

		last_frame = frame

		data = c(data, list(changes))
	}

	return(data)
}

cadg = compress_and_decimate_gif = function(folder.path, every_n = 1){
	files = list.files(folder.path)


	last_frame = readPNG(paste(folder.path, files[1], sep='/'))
	files = files[-1]

	files = files[every_n * (0:floor(length(files)/every_n))]

	data = list(which(last_frame != 0))

	for (filename in files){
		frame = readPNG(paste(folder.path, filename, sep='/'))

		changes = which(last_frame != frame)

		last_frame = frame

		data = c(data, list(changes))
	}

	return(data)
}




cvti = compress_vector_to_integer = function(vec){
		output = c()
		for (i in 1:(length(vec)/2)){
			 output = c(output, 2) #0.5 * 2^32 - vec[i*2 - 1] + vec[i*2] * 10^5
		}
		return(output)
}




#compress vector of integers
compress_vector = function(vec, intlength = 12){
	#R integers are stored in 32 bits. For a 64x64 display area, we only need 12-bit integers

	output = c()

	for (num in vec){
		string = intToBits(num)[intlength:1] == 1
		#to parse: `strtoi(paste(c('0','1')[1 + string], collapse=''), 2)`

		output = c(output, string)
	}

	bytelength = ceiling(length(output) / 8)

	comp_output = raw(length=bytelength)

	for (b in 1:bytelength){
		val = output[b * (1:8)]
		num = strtoi(paste(c('0','1')[1 + val], collapse=''), 2)
		byte = as.raw(num)

		comp_output[b] = byte
	}

	return(comp_output)
}; compress_vector(c(1:10)) -> cm; print(cm)


# packBits(intToBits(560),'integer')


#stores every frame in a list
store_gif = function(folder.path){
	files = list.files(folder.path)

	for (filename in files){
		frame = readPNG(paste(folder.path, filename, sep='/'))

		data = c(data, list(frame))
	}

	return(data)
}

#stores every frame serialized as a row in a matrix
serialize_gif = function(folder.path){
		files = list.files(folder.path)

		frame0 = as.vector(readPNG(paste(folder.path, files[1], sep='/')))

		data = matrix(0, ncol = length(frame0), nrow = length(files))

		for (i in 1:length(files)){
			frame = as.vector(readPNG(paste(folder.path, files[i], sep='/')))

			data[i,] = frame
		}

		return(data)
	}



#serial = serialize_gif('/Users/gabrielbroussardkorr/Desktop/rgifs/badapple/lores')

