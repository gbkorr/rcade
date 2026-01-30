# Render a Sprite to the Scene

I quite dislike this @example sir Overlays a sprite onto the desired
layer of the
[`scene`](https://gbkorr.github.io/rcade/reference/render.scene.md)
using
[`render.overlay()`](https://gbkorr.github.io/rcade/reference/render.overlay.md).

## Usage

``` r
render.sprite(scene, sprite, x, y, layer = 1, palette = NULL)
```

## Arguments

- scene:

  [Scene](https://gbkorr.github.io/rcade/reference/render.scene.md)
  object.

- sprite:

  Matrix of nonnegative integers corresponding to the pixels of a small
  image; see
  [`render.matrix()`](https://gbkorr.github.io/rcade/reference/render.matrix.md).

- x:

  X coordinate of where the sprite should be drawn on the scene.
  Specifically, this determines the position of top-left pixel of the
  sprite.

- y:

  Y coordinate for the same purpose.

- layer:

  Layer on which the sprite should be drawn. Higher layers are drawn on
  top.

- palette:

  Vector to swap the colors (numbers) of the sprite around, e.g.
  `c(0,2,1)` swaps values of 2 and 1. Index starts at 0. Defaults to no
  swapping.

## Value

Returns the
[scene](https://gbkorr.github.io/rcade/reference/render.scene.md) object
with sprite drawn.

## Examples

``` r
scene = list(width=24, height=6)
smiley = matrix(c(0,0,1,0,0,0,0,1,1,1,0,1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,0), ncol = 7)
box = matrix(1,12,9)
scene = render.sprite(scene, smiley, x=2, y=2)
#> Error in render.sprite(scene, smiley, x = 2, y = 2): could not find function "render.sprite"
scene = render.sprite(scene, smiley, x=11, y=2, layer = 2, palette = c(0,2,1)) #reversed colors
#> Error in render.sprite(scene, smiley, x = 11, y = 2, layer = 2, palette = c(0,     2, 1)): could not find function "render.sprite"
scene = render.sprite(scene, box, x=10, y=1)
#> Error in render.sprite(scene, box, x = 10, y = 1): could not find function "render.sprite"
render.scene(scene)
#> Error in render.scene(scene): could not find function "render.scene"
```
