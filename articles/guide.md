# Basic Package Usage

Welcome to `rcade`! This is a package that allows you to make and play
live-input games in vanilla R.

This article describes how to use the package to play games; see
[`vignette("rcade")`](https://gbkorr.github.io/rcade/articles/rcade.md)
for an overview of the package itself, or
[`vignette("engine")`](https://gbkorr.github.io/rcade/articles/engine.md)
for info on how the games run.

## 1. How to Play a Game

To play a game, you’ll need two RStudio[¹](#fn1) sessions open in
separate windows.

One of them, which I’ll call the **display session**, will display the
game’s graphics; it should be a relatively large window, and you’ll want
to zoom out with `cmd -` or equivalent.

The second sessions is the **input session** and will be where you’ll
interact with the game once it starts.

[IMAGE OF A GOOD
SETUP](https://gbkorr.github.io/rcade/articles/A%20good%20setup.%20The%20display%20session%20is%20large%20and%20zoomed%20out,%20and%20the%20input%20session%20is%20accessible.)

Once you have those two windows open, follow these steps:

1.  **Both sessions** need to load the package with
    [`library(rcade)`](https://gbkorr.github.io/rcade/).
2.  In the **display session**, start the game you want to play. I
    recommend `SuperRrio`:

&nbsp;

    quickload(SuperRrio)

3.  Then, go to the **input session** and run

&nbsp;

    inputs.listen()

4.  You should now be able to enter text in the input session to control
    the game!  
    The control scheme for Super Rrio is `A/D` to move and `SPACE` to
    jump.

Because of how R works, you have to **press Enter** every time you want
to send an input. So to jump right, you’d press the keys `W-SPACE-ENTER`
in succession.

[GIF of this!](https://gbkorr.github.io/rcade/articles/)

## 2. Prebuilt Games

Below are the ROMs (games) I’ve made to be included in the package. To
run one, follow the steps above with the desired ROM in
[`quickload()`](https://gbkorr.github.io/rcade/reference/quickload.md).

### Snake

    quickload(Snake)

[IMAGE](https://gbkorr.github.io/rcade/articles/) Classic Snake game
controlled with WASD. When you load the ROM, you’ll be prompted if you
want to use the default settings or change the speed and boundaries of
the game.

### Super_Rrio

[IMAGE](https://gbkorr.github.io/rcade/articles/)

### Bad Apple

[IMAGE](https://gbkorr.github.io/rcade/articles/) This one isn’t a game,
just a tech demo for the graphics engine. Running this will render a
video to the console, no input session needed.

### R²Studio

[IMAGE](https://gbkorr.github.io/rcade/articles/) desc Pronounced
“r-squared studio”— it’s a pun on the Pearson r², and the fact that it’s
RStudio in RStudio!

[TODOTDO](https://gbkorr.github.io/rcade/articles/)

## 3. Making Games

You can make your own game with
[`rom.init()`](https://gbkorr.github.io/rcade/reference/rom.init.md);
`vignette("Snake")` is a full devlog of the process of making the Snake
ROM from start to finish. Once you’ve made a ROM, you can run it just
like the games above!

The other game articles above go into more detail about game logic and
technical implementations and may be useful for advanced game
development.

------------------------------------------------------------------------

1.  This package only works in RStudio, since regular R doesn’t support
    console wiping with `cat('\f')`.
