


.onAttach = function(libname, pkgname){
	#create sanctioned local package data directory
	path = tools::R_user_dir('rcade')
	if (!dir.exists(path)) dir.create(path, recursive=TRUE)

	packageStartupMessage(paste('
[][][]  [][][]    []    [][]    [][][]
[][]    []      [][][]  []  []  [][]
[]  []  [][][]  []  []  [][]    [][][]  v',utils::packageVersion('rcade'),'

Open `vignette("guide")` to get started!
',sep=''))
	#I'm aware there are prettier ASCII fonts out there, I'm using the game's default font.

	if (is.na(Sys.getenv("RSTUDIO", unset = NA))) warning('Please use RStudio! rcade may not work in other environments.')
}

