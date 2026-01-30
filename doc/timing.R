## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------
library(diagram)

dig = function(title='',before=1,after = 1){
	xlim = c(0 - before,after)
	plot(NULL,xlim=xlim,ylim=c(0,2),axes='false',ylab='',xlab='')
	text(0-before,0.2,title,cex=1,adj=0)

	
	#arrows(xlim[1],0,xlim[2],0, xpd = TRUE, angle = 20)

	width = 0.02
	rect(0,0.5,1,1.5,border=NA,col='#cfb')
	#rect(-width*2,0.5,width*2,1.5)
	rect(-width,0.5,width,1.5,col='white')
	if (after > 0) for (i in 1:after) rect(i-width,0.5, i + width,1.5,col = 'black')
	if (before > 0) for (i in 1:before) rect(-i - width,0.5, -i + width,1.5,col = 'black')
	
	
	axis(1,at=c(-100,100),pos=0.5)
}


spot = function(x,white=FALSE){
	points(x,1,cex=ifelse(white,2,4/3),pch=ifelse(white,21,19),bg='white')
}

move = function(x1,x2,straight=FALSE){
	sig = sign(x1-x2)
	offset = ifelse(straight,sig * 0.08, 0)
	curvedarrow(c(x1,1),c(x2 + offset,1),arr.pos = ifelse(straight,1,0.9),endhead=TRUE,arr.type='triangle',curve=ifelse(straight,0,sig),xpd = TRUE,arr.length=0.15,arr.width=0.15)
}


#E
#par(mfrow=c(4,1),mar=c(0,0,0,0))
#dig('',0,0); spot(0.5); move(0.5,0.25,1); spot(0.25,1)
#dig('',0,0); spot(0.25); move(0.25,-0.5,1); spot(-0.5,1)
#dig('',0,0); spot(-0.5); move(-0.5,0.5); spot(0.5,1)




animate = function(titles,before,after,...){ #make the first point >100 to skip the first draw
	l = ...length()
	x = ..1

	panels = length(titles)
	par(mfrow=c(panels,1))
	
	labl = paste('1. ',titles[1],sep='')
	if (titles[1] == 'omit') {
		labl = titles[2]
		panels = panels - 1
		
		
		par(mfrow=c(panels,1))
	}
	else {dig(labl,before,after); spot(x,1)}
	
	if (l > 1) for (i in 1:(l-1)){
		newx = ...elt(i+1)
		labl = paste(i+1,'. ',titles[i+1],sep='')
		if (titles[1] == 'omit') labl = titles[i+1]
		dig(labl,before,after)
		for (p in newx){
			if (p!=x){
				spot(x)
				move(x,p,ifelse(p < x,TRUE,FALSE))
			}
			x = p
		}
		spot(x,1)
	}
}


#E
#animate('',0,0,0.5,0.25,-0.5,0.5)



#we'll need to define the plot sizes for these in the quarto page

#main
#animate(c('begin','sleep to the start of next frame','update RAM (advances 1 frame)','draw (takes a little time)','caught up'),0.5,1,0.2,-0.2,c(0.8,0.5),0.2,0.2)

#behind
#animate(c('begin','update','update','draw','caught up'),1,1,-0.8,c(0.2,-0.1),c(0.8,0.5),0.2,0.2)

#far behind
#animate(c('begin','update until ahead','draw','caught up'),4,1,-3.6,-c(2.6,2.9,1.9,2.2,1.2,1.5,0.5,0.8,-0.2,0.1,-0.9,-0.6),0.2,0.2)

#frameskipping
#animate(c('begin','update','draw (longer than a frame)','update twice','draw','etc. (two frames per draw)'),1.5,1,-0.6,c(0.4,0.1),-1.2,c(-0.2,-0.5,0.5,0.2),-1.2,c(-0.2,-0.5,0.5,0.2))




## ----fig.width=5, fig.height=2------------------------------------------------
par(mar=c(1,0,0,0))

dig('',2,2); spot(0.5); spot(0.2,1); move(0.5,0.25,TRUE)
text(0.5,0.4,'\ncurrent frame;\n"sweet spot"',cex=0.8,adj=0.5)
text(1.5,0.4,'next frame',cex=0.8,adj=0.5)
text(-0.5,0.4,'previous frame',cex=0.8,adj=0.5)
text(-1.5,0.4,'two frames prior',cex=0.8,adj=0.5)
axis(1,at=c(-2,-1,0,1,2),pos=0.5)
title(xlab='Frames ahead of time.sec()',line=0)

curvedarrow(c(0.5,1),c(0.8,1.7),segment = c(0.2,0.8), curve=0, arr.type='none',lwd=0.5)
text(0.8,1.7,'previous position',cex=0.8,adj=0)

curvedarrow(c(0.2,1),c(-0.3,1.7),segment = c(0.1,0.8), curve=0, arr.type='none',lwd=0.5)
text(-0.2,1.7,'current RAM position',cex=0.8,adj=1)

## ----fig.width=5, fig.height=2------------------------------------------------
par(mar=c(0,0,0,0))
animate(c('omit','RAM is behind where it should be.'),3,1,-2.5,-2.5)

## ----fig.width=4, fig.height=3------------------------------------------------
par(mar=c(0,0,0,0))

animate(c('omit','The RAM moves backwards as time passes.','RAM is updated 3 times, advancing 3 frames.'),3,0.8,0.4,-2.8,c(-1.8,-0.8,0.2))

## ----fig.width=3, fig.height=4------------------------------------------------
par(mar=c(0,0,0,0))
animate(c('begin','time passes','time passes; RAM is now behind current frame','RAM advances; back where it started'),0.8,1,0.5,0.25,-0.5,0.5)

## ----fig.width=2, fig.height=4------------------------------------------------
par(mar=c(0,0,0,0))
animate(c('begin','sleep to the end of this frame','update RAM (advances 1 frame)','draw (takes a little time)','repeat'),0.5,1,0.2,-0.2,c(0.8,0.6),0.2,0.2)

## ----fig.width=2, fig.height=4------------------------------------------------
par(mar=c(0,0,0,0))
animate(c('begin (behind)','update (still behind)','update (now ahead)','caught up'),1,1,-0.8,c(0.2,-0.1),c(0.8,0.5),0.5)

## ----fig.width=5, fig.height=3------------------------------------------------
par(mar=c(0,0,0,0))
animate(c('begin','update until ahead','caught up'),4,1,-3.6,-c(2.6,2.9,1.9,2.2,1.2,1.5,0.5,0.8,-0.2,0.1,-0.9,-0.6),0.6)

## ----fig.width=2, fig.height=4------------------------------------------------
par(mar=c(0,0,0,0))
animate(c('begin','update','draw (longer than a frame)','update twice','draw','etc. (two frames per draw)'),1.5,1,-0.6,c(0.4,0.1),-1.2,c(-0.2,-0.5,0.5,0.2),-1.2,c(-0.2,-0.5,0.5,0.2))

