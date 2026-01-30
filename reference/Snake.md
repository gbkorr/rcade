# Snake Game

Plays the classic game Snake. A full walkthrough of the creation of this
ROM can be found in
[`vignette("snake")`](https://gbkorr.github.io/rcade/articles/snake.md).

## Usage

``` r
Snake
```

## Format

A game [ROM](https://gbkorr.github.io/rcade/reference/rom.init.md); see
[`vignette("engine")`](https://gbkorr.github.io/rcade/articles/engine.md).

## How to Play

WASD to move the snake. `ENTER` *must* be pressed after each input for
it to be registered.

Follow these steps:

1.  `quickload(Snake)`

2.  Follow console prompt.

3.  Open new R session and load `rcade` with
    [`library(rcade)`](https://gbkorr.github.io/rcade/).

4.  [`inputs.listen()`](https://gbkorr.github.io/rcade/reference/inputs.listen.md)
    in that new session.

5.  Use WASD to control snake.

When you run
[`quickload()`](https://gbkorr.github.io/rcade/reference/quickload.md),
the game will ask if you want to keep the default settings or input your
own. The default settings are:

`5` frames per second  
`32x16` bounding area  
`10` starting snake length  
