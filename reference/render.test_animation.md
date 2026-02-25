# Test an Animated Sprite

Plays a sprite's animation into the console. `^C` to stop.

## Usage

``` r
render.test_animation(spritename, sprites)
```

## Arguments

- spritename:

  Name of sprite in `sprites`

- sprites:

  List of sprites, e.g. `ROM$sprites`.

## Details

This function is intended to aid in the sprite creation process.

It handles `sprite$next_animation` properly, so it can be used to test
multi-stage animations too.

## Examples

``` r
if (FALSE) { # \dontrun{
sprites = list(
bird.flap = list(
  framerate = 12, #frames per second
  frames = list(
    render.makesprite('
 O    O
OOO  OO
   OO
 OOOOOOO
OOOO

'),
    render.makesprite('


OOO  OOOO
O OOOOOOO
OOOO   OO

'),
    render.makesprite('



   OOOOOO
 OOOOO
OO     OOO
')
  )
)
)


render.test_animation('bird.flap',sprites)
} # }
```
