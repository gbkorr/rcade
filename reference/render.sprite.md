# Render a Sprite to the Scene

Overlays a sprite onto the desired layer of the
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
