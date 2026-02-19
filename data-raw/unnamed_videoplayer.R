
#how do we specify that these are needed for this one
library(av)
library(jpeg)


#this is the PERFECT vignette to examine RAM$debug to stresstest drawing capabilities


#use a readline() in ROM$startup() to ask for the filepath to video


RENAMEVIDEO = rom.init(64,64,framerate=30)

RENAMEVIDEO$startup = function(RAM){
	RAM$objects$video = list(
		draw = function(scene,obj,RAM){
			frame = RAM$ticks

			sprite = render.image(readJPEG(RAM$data[frame]),RAM$ROM$screen.width)

			scene = render.sprite(scene, sprite)

			return(scene)
		}
	)

	RAM$data = av_video_images('/Users/gabrielbroussardkorr/Desktop/music/Youtube Archive/hacona/Spring Rain ｜ 春雨.mp4')

	return(RAM)
}


#MAKE THIS A DEFAULT PART OF RCADE!!
render.image = function(img,size=64){
	by = floor(ncol(img)/size)

	#nearest-neighbor downsample
	img = img[seq(1,nrow(img),by),seq(1,ncol(img),by),]

	#luma greyscale
	img = 0.2126 * img[,,1] + 0.7152 * img[,,2] + 0.0722 * img[,,3]

	#werness dither
	kernel = rbind(c(0,0,0,0,0),c(0,0,0,0,0),c(0,0,0,26,7),c(0,16,26,16,0),c(0,0,7,0,0))/232
	krange = -2:2

	#error diffusion
	for (y in 3:(nrow(img)-2)) for (x in 3:(ncol(img)-2)){
		val = img[y,x]
		filt = round(val)
		img[y,x] = filt
		error = val - filt
		img[y+krange,x+krange] = img[y+krange,x+krange] + kernel * error
	}

	return(img)
}




