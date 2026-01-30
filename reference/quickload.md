# Play a Game

Starts a game immediately using a ROM.

## Usage

``` r
quickload(ROM)
```

## Arguments

- ROM:

  [ROM](https://gbkorr.github.io/rcade/reference/rom.init.md) to play.

## Details

Convenience wrapper for the code:

    RAM = ram.init(ROM)
    RAM = ram.run(RAM)

This saves RAM in the environment in which `quickload()` was called, so
the RAM can be accessed afterwards as if it were run manually.

## Examples

``` r
quickload(Snake)
#> Error in quickload(Snake): could not find function "quickload"
```
