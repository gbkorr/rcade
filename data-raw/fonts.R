

fonts.3x3 = list(
	width = 3,
	height = 3,

	kerning = 1,
	linespacing = 2,

	sprites = c(
		render.makefont('uppercase',width=3,'
 o  oo  ooo oo  ooo ooo  o  o o ooo ooo o o o   o o ooo ooo ooo  o  ooo  oo ooo o o o o o o o o o o oo
ooo ooo o   o o oo  oo  o   ooo  o   o  oo  o   ooo o o o o ooo o o oo   o   o  o o o o ooo  o   o   o
o o ooo ooo oo  ooo o   ooo o o ooo oo  o o ooo ooo o o ooo o    oo o o oo   o  ooo  o  ooo o o  o   oo
'),
render.makefont('numbers',width=3,'
 o  oo  oo    o  oo  oo o   ooo  oo ooo
o o  o   o   oo ooo  o  ooo   o ooo ooo
 o  ooo  oo oo    o oo  ooo  o  oo    o
'),
render.makefont('symbols',width=3,'
 oo oo   oo oo   oo oo    o o    o       o    o ooo   o         o   o    o  o o o     o  oo ooo ooo  oo o o  o  oo       o  o
o     o  o   o  oo   oo  o   o  ooo ooo      o      ooo     o            o  o o  o    o   o ooo ooo  o   o  o o oo       o   o
 oo oo   oo oo   oo oo    o o    o          o   ooo o   o   o   o   oo              o   o   ooo ooo oo  o o     ooo ooo  o    o
')
	)
)

fonts.3x5 = list(
	width = 3,
	height = 5,

	kerning = 1,
	linespacing = 2,

	sprites = c(
		list(
#custom characters
ß = render.makesprite(' #for R^2Studio
o
 o
ooo


')
),
render.makefont('lowercase',width=3,'
    o         o      oo     o    o    o o                                    o
    o         o oo  o    oo o           o   oo              oo  oo       o  ooo                 o o oo
 oo oo   oo  oo oo  o    oo oo   o    o o o  o  ooo oo   o  oo  oo  ooo o    o  o o o o o o o o  oo  o
o o o o o   o o o   oo    o o o  o    o oo   o  ooo o o o o o    o  o    o   o  o o o o ooo  o    o o
 oo oo   oo  oo  o  o   oo  o o  oo oo  o o  o  o o o o  o  o    oo o   o    o   oo  o  o o o o oo  oo
'),
render.makefont('uppercase',width=3,'
 o  oo   oo oo  ooo ooo  oo o o ooo ooo o o o   o o   o ooo oo   o  oo   oo ooo o o o o o o o o o o ooo
o o o o o   o o o   o   o   o o  o    o o o o   ooo o o o o o o o o o o o    o  o o o o o o o o o o   o
o o oo  o   o o oo  oo  o   ooo  o  o o oo  o   ooo ooo o o oo  o o oo   o   o  o o o o ooo  o   o   o
ooo o o o   o o o   o   o o o o  o  o o o o o   o o ooo o o o   ooo o o   o  o  o o o o ooo o o  o  o
o o oo   oo oo  ooo o    oo o o ooo  o  o o ooo o o o o ooo o    oo o o oo   o  ooo  o  o o o o  o  ooo
'),
render.makefont('numbers',width=3,'
 o   o  oo  oo  o o ooo  oo ooo ooo  oo
o o oo  o o   o o o o   o     o o o o o
o o  o    o  o  ooo oo  oo   o   o   oo
o o  o   o    o   o   o o o  o  o o   o
 o  ooo ooo oo    o oo   o  o   ooo   o
'),
render.makefont('symbols',width=3,'
  o o    oo oo    o o     o o           o o   o                          o  o o o   o   oo  ooo o o  o  o o  o   o       o  o
 o   o   o   o   o   o   o   o   o       o    o ooo   o         o   o    o  o o  o  o     o ooo ooo  oo   o o o o o      o  o
 o   o   o   o  oo   oo o     o ooo ooo o o  o      ooo                             o    o  ooo o o oo   o       o       o   o
 o   o   o   o   o   o   o   o   o          o   ooo o        o       o                      ooo ooo  oo o       oo       o    o
  o o    oo oo    o o     o o               o           o   o   o   o               o    o  ooo o o oo  o o     ooo ooo  o    o
')
	)
)





usethis::use_data(fonts.3x3, overwrite = TRUE)
usethis::use_data(fonts.3x5, overwrite = TRUE)
