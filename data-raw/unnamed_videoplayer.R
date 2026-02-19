
#how do we specify that these are needed for this one
library(av)
library(jpeg)


#this is the PERFECT vignette to examine RAM$debug to stresstest drawing capabilities

#change badapple to stream the video instead of loading it to frames (Which is super slow)


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

	RAM$sprites = lapply(RAM$data,readJPEG)

	return(RAM)
}


#it's worth noting this compression is a lot less effective on dithered video, since the dithering can spread and update random pixels

#dithers. I think all this stuff will make a nice bonus package or smth
#and this will certainly count as a project for compvis!
render.compress_video = function(av_data,size=64){
	n_frames = length(av_data)
	compressed = vector('list',n_frames)

	lastframe = 0
	for (i in 1:n_frames) {
		frame = render.image(readJPEG(av_data[i]),size)
		compressed[[i]] = which(frame != lastframe)
		lastframe = frame

		cat('\rCompressing frame ',i,'/',n_frames,'; ',floor(100 * i/n_frames),'%.      ',sep='')
	}

	return(compressed)
}

#once that's done, use a readLine prompt to ask to play

#this ROM needs playback options! play, pause, restart, maybe even rewind (or ffwd: combining arbitrary frames is instant as long as we don't render them)

render.stream_video = function(CURRENTFRAME,VIDEODATA,FRAMENUM){
		NEXTFRAME = VIDEODATA[[FRAMENUM]]
		CURRENTFRAME[NEXTFRAME] = !CURRENTFRAME[NEXTFRAME]
		return(CURRENTFRAME)
}


#I wish rom.init were called rom.makerom or smth. oh well, neither is great
VIDEOSTREAM = rom.init(128,128,framerate=12,custom=function(RAM){
	RAM$currentframe = render.stream_video(RAM$currentframe, comps, RAM$ticks)
	return(RAM)
})

VIDEOSTREAM$startup = function(RAM){
	RAM$currentframe = matrix(0,96,128) #need a way to detect size of video
	RAM$objects$video = list(
		draw = function(scene,obj,RAM){
			scene = render.sprite(scene, RAM$currentframe)

			return(scene)
		}
	)
	return(RAM)
}

#given that this can comfortably run 128x96 at 12fps (albeit with flickering), this is clearly a good idea.





#MAKE THIS A DEFAULT PART OF RCADE!!
render.image = function(img,size=64){
	#pad size to account for cropping later
	size = size + 4

	by = ncol(img)/size

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

	#crop diffusion border
	img = img[3:(nrow(img)-2),3:(ncol(img)-2)]

	return(img)
}




