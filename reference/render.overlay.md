# Overlay Two Matrices

This function overlays two sprites, respecting transparency (values of
0).

Specifically, `sprite` is placed on top of `background`, and its
position can be altered by specifying `x` and `y`. Then the new
`background` with the sprite atop it is returned; any part of `sprite`
outside its bounds is ignored.

## Usage

``` r
render.overlay(background, sprite, x = 1, y = 1, invert = FALSE)
```

## Arguments

- background:

  A sprite; a matrix of nonnegative integers corresponding to the pixels
  of a small image; see
  [`render.matrix()`](https://gbkorr.github.io/rcade/reference/render.matrix.md).

- sprite:

  Another sprite to overlay on `background`.

- x:

  X coordinate of where the sprite should be drawn on the scene.
  Specifically, this determines the position of top-left pixel of the
  sprite.

- y:

  Y coordinate for the same purpose.

- invert:

  Whether or how `background` should have its colors inverted; see
  below.

## Value

Returns `background` with `sprite` drawn on it.

## Inversion

Non-`FALSE` values of `invert` will invert the colors of `background`
where `sprite` is opaque (nonzero).

If `invert` is `TRUE`, `background` is assumed to be monochrome and
values of 1 and 2 (black and white) are swapped.

If `invert` is a vector of values, it will be used as an ordered lookup
for how to invert the values `0, 1, 2, 3, etc.` in `background`. For
example, `c(1,2,1)` will change 0-\>1, 1-\>2, and 2-\>1 and throw an
error if `background` contains a value higher than 2.

This is mainly to provide functionality for multicolor systems, where
the function wouldn't know how to invert arbitrary values.

## Conceptual Usage

NOTE: this function will clip out any part of `sprite` that falls out of
bounds of `background`; in these examples, the boxes are padded with
extra space.

       = 0 (transparent)
    [] = 1 (black)
    .  = 2 (white)


    [][][][][]                    [][][][][]
    []. . . []                    []. . . []
    []. . . []     [][][][][]     []. [][][][][]
    []. . . []  +  []. . . []  =  []. []. . . []
    [][][][][]     []. . . []     [][][]. . . []
                   []. . . []         []. . . []
                   [][][][][]         [][][][][]

    Transparency:

    [][][][][]                    [][][][][]
    []      []                    []      []
    []      []     [][][][][]     []  [][][][][]
    []      []  +  []      []  =  []  []  []  []
    [][][][][]     []      []     [][][][][]  []
                   []      []         []      []
                   [][][][][]         [][][][][]

    Inversion:

    [][][][][]. .                     [][][][][]. .
    [][][][][]. .                     [][][][][]. .
    [][][][][]. .      [][][][][]     [][]. . . [][]
    [][][][][]. .   ~  [][][][][]  =  [][]. . . [][]
    [][][][][]. .      [][][][][]     [][]. . . [][]
    . . . . . . .      [][][][][]     . . [][][][][]
    . . . . . . .      [][][][][]     . . [][][][][]

      print('wow')
    #> [1] "wow"

i hate these examples

## Examples

``` r
bg = matrix(2,7,7)

box = matrix(1,5,5)
box.white = box; box.white[2:4,2:4] = 2
box.transparent = box; box.transparent[2:4,2:4] = 0

#using pipes for conciseness; see ?pipeOp
#example 1
bg |>
  render.overlay(box.white) |>
  render.overlay(box.white, 3, 3) |>
  render.matrix()
#> Error in render.matrix(render.overlay(render.overlay(bg, box.white), box.white,     3, 3)): could not find function "render.matrix"

#transparency
bg |>
  render.overlay(box.transparent) |>
  render.overlay(box.transparent, 3, 3) |>
  render.matrix()
#> Error in render.matrix(render.overlay(render.overlay(bg, box.transparent),     box.transparent, 3, 3)): could not find function "render.matrix"

#inversion
bg |>
  render.overlay(box) |>
  render.overlay(box, 3, 3, invert=TRUE) |>
  render.matrix()
#> Error in render.matrix(render.overlay(render.overlay(bg, box), box, 3,     3, invert = TRUE)): could not find function "render.matrix"
```
