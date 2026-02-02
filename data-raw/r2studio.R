
#can I hack this by writing to RAM with code? I think I can! Demo this by, in the program itself, changing the font
#and changing height, etc.
#RAM$ROM$screen.width = 64
#RAM$font = fonts.3x3

#wrap these as custom functions for the engine

#envvars and plot are just drawn over the rest of everything, controlled by the plot window's width and height vars (tied to RAM)
#remember to layer correctly for that!
#(plot canvas draws that whole two-part side (like two stacked boxes))

#we have room for environment varaibles!!!!



#PLS HAVE DARKMODE IT WOULD BE SO COOL
#that means putting everything on invert or smth NO it just means swapping the palette in ROM :)
#in fact, maybe demo this with snake


# "we can also... boot up the R2Studio ROM in this environment. The package is actually functional in this state, but you have to influence it manually--- by using ram.input() and ram.tick(). ram.run won't work for several reasons.
#how cool is that! it's r-cubedstudio. And here's me in the middle of a very slow game of snake in rstudio in rstudio.


# Initialization ----
#320, 200
R2Studio = rom.init(100,25,framerate=1)

# Graphics ----

R2Studio$draw_ui = function(scene, RAM){
	#we do this live because we have plenty of time (at 1fps!) and because it lets us change things

	#border
	box = matrix(1,RAM$ROM$screen.height,RAM$ROM$screen.width)
	box[2:(nrow(box) - 1), 2:(ncol(box) - 1)] = 0
	scene = render.sprite(scene, box, 1, 1, layer=4)

	#top bar
	box = matrix(1,RAM$font$height + 2,RAM$ROM$screen.width)
	scene = render.sprite(scene, box, 1, 1, layer=4)

	#top console text
	consoletext = 'RßStudio v.1.0'
	consoletext = render.text(consoletext,RAM$font)
	consoletext[consoletext == 1] = 2 #convert to white
	scene = render.sprite(scene, consoletext, 3, 1, layer=4)

	plottitle = 'plot'
	if (RAM$objects$plotwindow$main != '') plottitle = RAM$objects$plotwindow$main
	plottitle = render.text(plottitle,RAM$font,alignment='center',wrap=RAM$objects$plotwindow$width)
	plottitle[plottitle == 1] = 2 #convert to white
	scene = render.sprite(scene, plottitle, RAM$ROM$screen.width - RAM$objects$plotwindow$width + 2, 1, layer=4)

	return(scene)
}

R2Studio$draw_console = function(scene, RAM){
	rows = (RAM$ROM$screen.height + 1)/(RAM$font$height + 1) - 1 #number of lines there's room to draw

	console = RAM$objects$console
	output = ''
	for (line in length(console$text):1){
		#don't draw offscreen text
		if (line < length(console$text) - rows + 2) break

		output = paste(console$text[line],output,sep='\n')
	}

	sprite = render.text(output, font = RAM$font)
	scene = render.sprite(scene, sprite, 3, RAM$font$height + 3)

	return(scene)
}

R2Studio$drawplot = function(scene, RAM){
	list2env(RAM$objects$plotwindow, envir = environment()) #load object data

	#width is in the object
	height = RAM$ROM$screen.height - RAM$font$height - 1

	#xvals, xlim, xlab
	#yvals, ylim, ylab
	#pch, cex
	#type, main

	#make plot window as sprite
	box = matrix(1, height, width)
	box[2:(nrow(box) - 1), 2:(ncol(box) - 1)] = 2 #white opaque background to block out the console text

	#create scene with plot winodw
	plt = list(width =  width, height = height, layers=list(box))

	if (length(xvals)) {
		#limits
		if (is.null(xlim)) {
			xlim = range(xvals)
			xlim = 1.2 * (xlim - mean(xlim)) + mean(xlim)
		}
		if (is.null(ylim)){
			ylim = range(yvals)
			ylim = 1.2 * (ylim - mean(ylim)) + mean(ylim)
		}

		for (i in 1:length(xvals)){
			px = xvals[i] #point x
			py = yvals[i]

			#shrink into limits
			px = round((px - xlim[1]) * (width - 3) / (xlim[2] - xlim[1]))
			py = round((py - ylim[1]) * (height - 3) / (ylim[2] - ylim[1]))

			#add point
			if (type == 'p'){
				#listed pch and cex
				if (length(pch) > 1) pch = pch[i]
				if (length(cex) > 1) cex = cex[i]

				sprite = RAM$ROM$pch(pch, cex)

				plt = render.sprite(plt, sprite, px + 1 - ceiling(ncol(sprite)/2), height - py - 2 - ceiling(nrow(sprite)/2), layer=1)
			}
		}
	}

	plt = plt$layers[[1]] #get window layer from plt as sprite
	scene = render.sprite(scene, plt, RAM$ROM$screen.width - width + 1, RAM$font$height + 2, layer = 3)
}

R2Studio$pch = function(pch, cex){
	size = floor(2 * 2 * cex)/2 #half width
	sprite = matrix(0,size*2,size*2)
	for (x in -0.5 + (1-size):size) for (y in -0.5 + (1-size):size){
		sprite[size + y + 0.5, size + x + 0.5] = switch(pch,
				(floor(sqrt(x^2+y^2)) == (size - 1)) # STILL DOESNT WORK EXACTLY RIGHT TODOTODOTODOTODO


		)
	}
	return(sprite)
} #generates sprite on the spot for a given pch and cex


# Hooked Functions ----
R2Studio$plot = function(RAM, x, y=NULL, xlim=NULL, ylim=NULL, xlab=NULL, ylab=NULL, main=NULL, pch=1, cex=1, type='p'){
	if (!(type %in% c('p','l'))) warning('plot warning\n: only types p and l supported')

	xvals = x
	yvals = y
	xlb = deparse(substitute(x)) #x label
	ylb = deparse(substitute(y)) #y label

	#no y provided; go by index instead
	if (is.null(y)){
		xvals = 1:length(x)
		yvals = x
		ylb = xlb
		xlb = "Index"
	}
	else if (length(x) != length(y)) cat('plot warning:\nx and y of different lengths')

	#manual labels and limits
	if (!is.null(xlab)) xlb = xlab
	if (!is.null(ylab)) ylb = ylab

	#update plot window
	RAM$objects$plotwindow[c('xvals','yvals','xlim','ylim','xlab','ylab','main','type','pch','cex')] = list(xvals,yvals,xlim,ylim,xlab,ylab,main,type,pch,cex)

	return(RAM)
}

R2Studio$use.size = function(RAM, new.width = NULL, new.height = NULL){

	if (!is.null(new.width)) RAM$ROM$width = floor(new.width)
	if (!is.null(new.height)) RAM$ROM$width = floor(new.height)

	return(RAM)
}
R2Studio$use.font = function(RAM, font = NULL, kerning = NULL, linespacing = NULL){
	if (!is.null(font)) RAM$font = font

	if (!is.null(kerning)) RAM$font$kerning = kerning
	if (!is.null(linespacing)) RAM$font$linespacing = linespacing

	return(RAM)
}

# Core ----
R2Studio$evaluate = function(RAM,expr){

	#hook functions
	orig_expr = expr #record this for the console output
	for (hooked_function in c('plot','use.size','use.font')){

		#replaces expr 'hooked_function(...)' with 'RAM$ROM$hooked_function(RAM,...)'

		#todo: gsub

		if (substr(expr,1,1+nchar(hooked_function)) == paste(hooked_function,'(',sep='')) {
			expr = paste(
				'RAM = RAM$ROM$',
				hooked_function,
				'(RAM,',
				substring(expr,2+nchar(hooked_function)),
				sep = ''
			)
		}
	}


	RAM$environment$RAM = RAM #push RAM into its own environment so it can be edited on the fly

	#parse text as function |> evaluate function in RAM's environment |> capture output
	output = utils::capture.output(
		tryCatch(
			eval(
				parse(text=expr),
				envir=RAM$environment
			),
			error = function(err){cat('Error in',expr,':\n',err$message)} #return error message like in regular console
		)
	)

	RAM = RAM$environment$RAM #pull RAM back from environment


	#save expression and output to console
	exprlines = strsplit(orig_expr,'\n')
	RAM$objects$console$text = c(
		RAM$objects$console$text,
		paste(
			c('>',
				rep('+',length(exprlines)-1)
			),
			exprlines
		),
		output
	)

	return(RAM)
}



# Startup and Custom ----
R2Studio$startup = function(RAM){
	RAM$font = fonts.3x5

	RAM$environment = new.env() #environment R code will be run in

	RAM$n_expr = 1 #most recent expression to evaluate

	RAM$objects$console = list(
		text = c('RßStudio v.1.0','"Kaleidoscope"',paste('Platform: RStudio',RStudio.Version()$version)), #uses ß as a custom character to draw superscript 2
		draw = function(scene, obj, RAM){return(RAM$ROM$draw_console(scene, RAM))}
	)

	#graphics
	RAM$objects$gui = list(draw = function(scene, obj, RAM){return(RAM$ROM$draw_ui(scene, RAM))})
	RAM$objects$plotwindow = list(
		width = floor(RAM$ROM$screen.width/3), #height set automatically; width can be adjusted
		xvals = c(),
		yvals = c(),
		xlim = NULL,
		ylim = NULL,
		xlab = '',
		ylab = '',
		main = '',
		type = 'p',
		pch = 1,
		cex = 1,
		draw = function(scene, obj, RAM){return(RAM$ROM$drawplot(scene, RAM))})

	return(RAM)
}

#all this does is evaluate anything new
R2Studio$custom = function(RAM){
	#custom input retrieval
	if (nrow(RAM$inputs) > RAM$n_expr){
		#get text
		expr = paste(RAM$inputs$text[(RAM$n_expr+1):nrow(RAM$inputs)],sep='\n') #all inputs since the last one are concatenated into one multiline, (almost) exactly as they'd be parsed in the console. Conveniently, multiline inputs show up as sequential inputs on the same frame

		RAM = RAM$ROM$evaluate(RAM, expr)
		RAM$n_expr = nrow(RAM$inputs)
	}

	return(RAM)
}



# Save ----


#quickload(R2Studio)


#usethis::use_data(R2Studio, overwrite = TRUE)
