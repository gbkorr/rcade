
#' Fonts
#'
#' @description
#' Fonts are used to draw text ingame with [render.text()]. A font is a list including `$sprites`, a list of sprites for each character supported by the font.
#'
#' [really try/consider adding random demo photos all over the vignettes: they (esp. inputs and render) are way too dense. even in render you could replace some console examples with images]
#' All fonts are monospaced.
#'
#' @details
#' Fonts can have the following metadata:
#' ||||
#' |-|-|-|
#' |`$width`:|\verb{ }|Width of each character in the font, in pixels.|
#' ||||
#' |`$height`:||Height of each character in the font.|
#' ||||
#' |`$kerning`:||Default spacing between characters.|
#' ||||
#' |`$linespacing`:||Default vertical spacing between lines of text.|
#' ||||
#' |`$sprites`:||List of sprite matrices for each character.|
#'
#' @section render.makefont():
#' `render.makefont()` is a convenient extension of [render.makesprite()] to create batches of characters at once. To use it, enter a string of all characters in the `char_group` lined up horizontally (see examples).
#'
#' The function does NOT create a full font object; it just generates some of the `$sprites`.
#'
#' The function returns a list with a sprite set for each character. The sprites' widths must be set by `width`, while the height is determined by the number of newlines in `txt` like in `render.makesprite()`.
#'
#'	The `char_group`s are as follows:
#'
#'	||||
#'	|-|-|-|
#'	|`uppercase`:|\verb{  }|`abcdefghijklmnopqrstuvwxyz`|
#'	||||
#'	|`lowercase`:||`ABCDEFGHIJKLMNOPQRSTUVWXYZ`|
#'	||||
#'	|`numbers`:||`0123456789`|
#'	||||
#'	|`symbols`:||`()[]{}<>+-*/=~.,:;'"`\verb{`}`!?@#$%^&_|\`|
#'
#'	Missing characters will be replaced with empty sprites of the appropriate size.
#'
#'
#' @section Preinstalled Fonts:
#' The package comes with two fonts: [fonts.3x3] and the more detailed [fonts.3x5].
#'
#' @param char_group Character group to make sprites for; see below.
#' @param width Desired width for each character.
#' @param txt String to turn into fonts. All nonspace characters will be converted to `1` in the sprites.
#' @examples
#' #used for `fonts.3x3`:
#' example_font = list(
#'   width = 3,
#'   height = 3,
#'   sprites = render.makefont('uppercase',width=3,'
#'  o  oo  ooo oo  ooo ooo  o  o o ooo ooo o o o   o o ooo ooo ooo  o  ooo  oo ooo o o o o o o o o o o oo
#' ooo ooo o   o o oo  oo  o   ooo  o   o  oo  o   ooo o o o o ooo o o oo   o   o  o o o o ooo  o   o   o
#' o o ooo ooo oo  ooo o   ooo o o ooo oo  o o ooo ooo o o ooo o    oo o o oo   o  ooo  o  ooo o o  o   oo
#' ')
#' )
#'
#' render.matrix(cbind(
#'   example_font$sprites$H,
#'   matrix(0,3,1),
#'   example_font$sprites$I
#' ))
render.makefont = function(char_group = 'uppercase',width, txt){
	data = strsplit(txt, '\n', fixed = TRUE)[[1]][-1] #removes leading \n
	data = trimws(data, 'right')

	height = length(data)

	group = list(
		uppercase = LETTERS,
		lowercase = letters,
		numbers = strsplit('0123456789',split='')[[1]],
		symbols = strsplit(paste("()[]{}<>+-*/=~.,:;'",'"`!?@#$%^&_|\\',sep=''),split='')[[1]]
	)[[char_group]]

	output = list()

	for (i in 1:length(group)){
		sprite = matrix(0,0,width)
		for (line in data){
			row = c()
			for (pos in (1:width) + (i - 1) * (width + 1)){
				char = substr(line,pos,pos)
				if (char == ' ' || char == '') row = c(row, 0)
				else row = c(row, 1)
			}
			sprite = rbind(sprite,row)
		}
		rownames(sprite) = c() #rbind likes sneaking these in there
		output[[group[i]]] = sprite
	}

	return(output)
}

#' Test a Font
#'
#' @description
#' Prints a large sampler of text using a font to see how it looks in different contexts. You may have to zoom out with `cmd -` to see the text render properly.
#'
#' Alternatively, you can test fonts with something like `render.matrix(render.text('example_text', font_to_test))`.
#'
#' @param font [Font][render.makefont] to test.
#' @param verbose Boolean; print extra text samples?
#' @details
#' Uses [render.text()] to print the following:
#'
#' 1. lowercase pangram
#' 2. uppercase pangram
#' 3. code sample
#' 4. all symbols
#' 5. all numbers
#' 6. lowercase alphabet
#' 7. uppercase alphabet
#'
#' The alphabets are drawn last so they show up closest to the bottom of the console. Each of the things printed are useful for different purposes. If the font does not support some characters, the samples containing them will be omitted. (e.g. uppercase-only fonts skip the lowercase samples).
#'
#' [include a picture of] `render.test_font(fonts.3x5)`
#'
#' @section Verbose:
#' Use `verbose = TRUE` to print a few more samplers:
#'
#' 1. mixed case phrase
#'
#' 2. mixed cases and symbols
#' @examples
#' render.test_font(fonts.3x5)
render.test_font = function(font, verbose = FALSE){

	letters = paste(letters,collapse='')
	words = "the quick brown fox jumped over the lazy dog"
	code = 'for (i in 5 * (1:10)){
  print("Hello World.");
} #comment!
'
	captest = "Three Capital Letters Hopped Briskly"
	mixedtest = "Yes, too much... Punct-uation! It wasn't 3 o'clock yet; it was 2:30."
	numbers = "0123456789"
	symbols = paste("()[]{}<>+-*/=~.,:;'",'"`!?@#$%^&_|\\',sep='')

	wrap = 26 * (font$width + 1) #just enough for the alphabet

	if (!is.null(font$sprites$`a`)) render.matrix(render.text(words, font, wrap = wrap))
	if (!is.null(font$sprites$`A`)) render.matrix(render.text(toupper(words), font, wrap = wrap))

	if (verbose){
		if (!is.null(font$sprites$`A`)) render.matrix(render.text(captest, font, wrap = wrap))
		render.matrix(render.text(mixedtest, font, wrap = wrap))
	}

	if (!is.null(font$sprites$`+`)) render.matrix(render.text(code, font))

	if (!is.null(font$sprites$`+`)) render.matrix(render.text(symbols, font, kerning = 1, linespacing = 1))
	if (!is.null(font$sprites$`1`)) render.matrix(render.text(numbers, font, kerning = 1, linespacing = 1))
	if (!is.null(font$sprites$`a`)) render.matrix(render.text(letters, font, kerning = 1, linespacing = 1))
	if (!is.null(font$sprites$`A`)) render.matrix(render.text(toupper(letters), font, kerning = 1, linespacing = 1))
}




#' Render Text as Sprite
#'
#' Generates a sprite for a block of text, suitable for drawing with [render.matrix].
#' @param str String to make a sprite for.
#' @param font [Font][render.makefont] to render the text in.
#' @param kerning Pixels between characters horizontally. Otherwise the font's default `$kerning` will be used.
#' @param linespacing Pixels between characters vertically. Otherwise the font's default `$linespacing` will be used.
#' @param wrap Pixels of space alotted to a given line of text before a newline is automatically created. `NULL`: no text wrapping.
#' @param alignment `'left'`, `'center'`, or `'right'` text alignment.
#' @returns Returns a sprite matrix for the text.
#' @details
#' Characters missing from the font will be replaced with blank spaces. If the font only supports uppercase or lowercase, characters will be coerced to the supported case.
#'
#' @section Limitations:
#' This function was somewhat messily implemented, but it does its job. A rewrite would be appropriate someday.
#'
#' The function currently only supports the wrapping of whole words; individual words will not be split if they exceed the wrap length.
#'
#' Wrapping also does not work with strings that manually newline (i.e. with `\n`).
#'
#' @examples
#' sprite = render.text('Hello World.', fonts.3x5)
#' render.matrix(sprite)
#'
#' #alignment and wrapping
#' render.matrix(render.text(
#'   'this text is aligned to the right',
#'   wrap = 32,
#'   alignment = 'right'
#' ))
#'
#' #kerning and linespacing
#' render.matrix(render.text(
#'   'very spaced text',
#'   kerning = 3
#' ))
#'
#' #newlines with '\n'
#' render.matrix(render.text(
#'   'Newlines:\nAre supported.'
#' ))
render.text = function(str, font = rcade::fonts.3x3, wrap = FALSE, kerning = NULL, linespacing = NULL, alignment = 'left'){
	if (str == '') return(matrix(0)) #return empty pixel if no text

	lines = strsplit(str, '\n', fixed = TRUE)[[1]] #split newlines

	#kern and linespacing defaults
	if (is.null(kerning)) kerning = font$kerning
	if (is.null(kerning)) kerning = 1

	if (is.null(linespacing)) linespacing = font$linespacing
	if (is.null(linespacing)) linespacing = 1

	#WRAPPING DOES NOT WORK WITH NEWLINE CURRENTLY

	#width and height including the empty space for kerning and linespacing. the correct typographical term is "body" but that's confusing with html
	block.width = (font$width + kerning)
	block.height = (font$height + linespacing)

	#text wrapping
	if (wrap){
		cutoff = floor(wrap / block.width) #number of characters allowed
		newlines = c() #properly wrapped lines
		for (line in lines){
			words = strsplit(str, ' ', fixed = TRUE)[[1]]
			while (length(words) > 0){
				newline = words[1] #still works even if the word is too big
				if (length(words) > 1) {
					for (i in 2:length(words)){

						#attempt to add more words to this line
						trynewline = paste(newline,words[i])

						#end of line
						if (nchar(trynewline) > cutoff) {
							words = words[i:length(words)]
							break
						}
						else if (i == length(words)){
							words = c()
						}

						#otherwise add new word to line
						newline = trynewline
					}
				} else {words = c()} #clear last word
				#alignment
				buffer = (cutoff - nchar(newline)) * c(left = 0, center = 0.5, right = 1)[alignment]
				if (buffer > 0) newline = paste(paste(rep(' ', buffer), collapse = ''), newline, sep = '')

				newlines = c(newlines,newline)
			}
		}
		lines = newlines
	} #needs cleanup and commenting

	#size of the sprite to draw on scene
	sprite.width =   max(nchar(lines)) * block.width  #maximum width * font size parts
	sprite.height =  length(lines)     * block.height

	#initialize sprite
	sprite = matrix(0, ncol = sprite.width, nrow = sprite.height)

	for (l in 1:length(lines)){
		line = strsplit(lines[l], '')[[1]]

		for (c in 1:length(line)){
			char = line[c]

			if (length(char) == 0) next

			#try uppercase and lowercase
			charsprite = font$sprites[[char]]
			if (is.null(charsprite)) charsprite = font$sprites[[toupper(char)]]
			if (is.null(charsprite)) charsprite = font$sprites[[tolower(char)]]

			cx = (c - 1) * block.width
			cy = 1 + (l - 1) * block.height

			#if unset, keep empty
			if (!is.null(charsprite)) sprite[cy + 1:font$height, cx + 1:font$width] = charsprite
		}
	}

	return(sprite)
}

