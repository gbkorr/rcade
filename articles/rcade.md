# The 'rcade' Package

This article talks about the package itself. For how to use it, see
`vignettes("guide")`.

## 1. Manifest

Why does this package exist?

Until now, no games existed in R that could take live input from the
user. This changes that, and provides a powerful framework for creating
such games.

I came up with this project to give myself an opportunity to build a lot
of skills—package creation, documentation, etc.—while working on
something genuinely fun and cool.

## 2. Directory

This package comes with a full suite of vignettes detailing every aspect
of how things work. These are listed below with a short description:

### 2.1 General Vignettes

[`vignette("guide")`](https://gbkorr.github.io/rcade/articles/guide.md)
goes over **how to use the package** to play games.

[`vignette("engine")`](https://gbkorr.github.io/rcade/articles/engine.md)
describes the **high-level structure** of the game engine and its
systems.

[`vignette("snake")`](https://gbkorr.github.io/rcade/articles/snake.md)
provides a **full walkthrough of game creation** using the package.

\[MORE VIGS NEEDED: rrio, r2studio\]

### 2.2 Systems Vignettes

[`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md)
explains in detail how the game **runs at the right speed**.

[`vignette("inputs")`](https://gbkorr.github.io/rcade/articles/inputs.md)
describes how the engine **captures and interprets user input**.

[`vignette("render")`](https://gbkorr.github.io/rcade/articles/render.md)
details everything that goes into **drawing the game** to the console.

## 3. Prebuilt Games

\[COPY SECTIONS FROM GUIDE VIGNETTE?\]

### 3.1 Snake

[`vignette("snake")`](https://gbkorr.github.io/rcade/articles/snake.md)

\[IMAGE FOR EACH GAME\]

A port of the classic game Snake, running quite smoothly. Demonstrates
the interactivity of rcade well and serves as a great guide for ROM
creation.

### 3.2 Super Rrio

\[TODO TODO\]\[\]

### 3.3 Bad Apple

`vignette("badapple")`

\[IMAGE\]

This ROM is a proof of concept for the graphical capabilities of rcade,
which can comfortably play videos at resolutions exceeding 64x64.

Bad Apple is the canonical video to demonstrate the graphical
capabilities of hardware that… shouldn’t really have these graphical
capabilities. People have run it on everything from original IBM
[computers](https://www.youtube.com/watch?v=E0h8BUUboP0) to
[oscilloscopes](https://www.youtube.com/watch?v=7pzvEouWino) to
[calculators](https://www.youtube.com/watch?v=6pAeWf3NPNU) to glitching
[pokemon](https://www.youtube.com/watch?v=ciIkpw3glH4) to run the video
ingame via ACE.

I’m certainly not the first to make this on a CLI console, nor [in
R](https://www.youtube.com/watch?v=cCK_-yRJ0Ow). but I believe this is
the first time it’s been done on the R console.

### 3.4 R²Studio

`vignette("r2studio")`

\[IMAGE\]

It’s RStudio in RStudio\![¹](#fn1) This ROM draws its own little console
and plotting window, and the user can run R code by sending it through
the input system.

Running a program in itself is the pinnacle of wacky software
enginnering, in my mind.[²](#fn2) This really shows how robust rcade can
be when pushed to its limits.

(… yes, it can run itself too.)

## 4. History and Motivation

There are a few excellent resources[³](#fn3) detailing the former state
of R gaming.

Vanilla R games were restricted to text-based games; action games
required shiny or an equivalent package to take live input. But no
longer!

I wanted to make a game in base R! It started as a joke idea I pitched
to friends, and I ended up developing it into a full engine in Spring
2025. This engine was a bit different—– it used an in-console ASCII
display to run a simplified Super Smash Brothers-like game and featured
working multiplayer (!) using a node.js server. It worked quite well but
I abandoned it because… the fun was all in making it work.

In the winter, I realized this was an excellent opportunity to turn into
an R package for the sake of practice and exhibition. Many of the
concepts used by the package originate from the old engine, but all the
code is new and much nicer, and fully documented!

## 5. Goals

Adapting the systems from my original project, this package had many
goals:

- To run in base R with no dependencies! (excepting preinstalled
  packages like `tools`)

- To work as a cohesive package with high-quality, R-style code—
  e.g. proper handling of objects, no global assignments, and CRAN
  compatibility.

- To be a game *engine*, on which people can make their own games; the
  original project could only be used to play the one game it was
  designed for.

- To have thorough documentation and vignettes— these are a blast to
  write and I haven’t often gotten the opportunity to make them.

- Through all these, to be as convenient as possible for other people to
  use— much effort was spent manicuring the code and documentation to
  inter-reference cohesively and maximize readability. UX is a top
  priority for an R package!

I’m happy to say that this project achieved every goal, and it was a
pleasure to develop. Enjoy!

## 6. Notes

### 6.1 Style

I choose to write R code in a way that’s slightly easier for people
unfamiliar with R to understand;[⁴](#fn4) mainly forgoing the use of \<-
and declaring function returns explicitly.

Additionally, for the sake of organization, function names are prefixed
by general context— e.g., functions pertaining to “the rendering
process” take the form `render.foo()`. This is against S3 conventions
(where the prefix indicates what class a function operates on) but I
find it to be an immensely valuable tool for writing understandable
code.

### 6.2 The Name ‘rcade’

The name “rcade” was too perfect to pass up for a host of reasons. Two
packages already ‘exist’ with this name, but I don’t think this will
cause any conflict:

- A deprecated [bioconductor
  package](https://www.bioconductor.org/packages//2.12/bioc/html/Rcade.html)
  that was [removed](https://bioconductor.org/about/removed-packages/)
  from bioconductor and CRAN in 2015.

- An old github-only [package](https://github.com/RLesur/Rcade) that
  runs HTML5 games in R.

Both packages are obscure and nearly a decade old— may the R gods be
merciful on my usurping of the name.

### 6.3 AI Disclaimer

**No LLMs**[⁵](#fn5) were used in the making of this package. All
writing and code was done by me!

## 7. But Can it Run Doom?

Absolutely, but I’m not good at making 3D games. Someone else will have
to do the port.

------------------------------------------------------------------------

1.  And a pun on the Pearson r²!

2.  e.g. [Minecraft in
    Minecraft](https://www.youtube.com/watch?v=-BP7DhHTU-I).

3.  Many of these feature the same games.

    [“A Review of Games Written in R on
    CRAN”](https://www.r-bloggers.com/2022/09/a-review-of-games-written-in-r-on-cran/amp/)

    [“Games in R: Fun with Statistical
    Computing”](https://lucidmanager.org/data-science/games-in-r/)

    [“R Console Gaming”](https://rolkra.github.io/R-Console-Gaming/)

    [“Splendid R Games”](https://github.com/matt-dray/splendid-r-games)

4.  Which is particularly important for this project; the systems and
    concepts are generalizable to other languages and might actually be
    a good resource for making an engine like this.

5.  Except, of course, when the Google results suggested the right
    function before I could click on a stackexchange link saying the
    same thing.
