# Generate Sprite Matrix from Text

The engine needs sprites to be a matrix of numbers, but this is
inconvenient to do by hand. This function converts a string into a
sprite to allow the dev to easily create sprites.

By default, all non-space characters inputted will be converted to `1`
(black) pixels in the sprite, and space characters to `0` (transparent).

## Usage

``` r
render.makesprite(
  txt,
  width = NULL,
  default = 1,
  lookup = c(` ` = 0, . = 0, `_` = 2)
)
```

## Arguments

- txt:

  String to convert to matrix.

- width:

  Sprite width. This is usually set automatically.

- default:

  Number to which all characters not in `lookup` will be converted.

- lookup:

  Table for converting characters to non-`default` numbers.

## Value

Returns a sprite matrix suitable for
[`render.matrix()`](https://gbkorr.github.io/rcade/reference/render.matrix.md).

## Defaults

The height of the sprite matrix is equal to the number of newlines in
`txt`, as one might expect. The width is determined by the rightmost
non-space character, unless set manually.

Characters in `txt` are converted 1-1 with numbers defined by `default`
and `lookup`. The default character conversion is:

|                  |     |                   |
|------------------|-----|-------------------|
|                  |     |                   |
| ` ``' '`:        | ` ` | `0` (transparent) |
|                  |     |                   |
| ` ``'.'`:        |     | `0` (transparent) |
|                  |     |                   |
| ` ``'_'`:        |     | `2` (white)       |
|                  |     |                   |
| everything else: |     | `1` (black)       |

## Examples

``` r
smiley = render.makesprite('
  o o
  o o
o     o
 ooooo
')
#> Error in render.makesprite("\n  o o\n  o o\no     o\n ooooo\n"): could not find function "render.makesprite"

render.matrix(smiley)
#> Error in render.matrix(smiley): could not find function "render.matrix"

#multicolor
palette =
badger = render.makesprite('
  O O
=     =
 HHHHH
', lookup = c(' ' = 0, 'O' = 1, '=' = 2, 'H' = 3))
#> Error in render.makesprite("\n  O O\n=     =\n HHHHH\n", lookup = c(` ` = 0,     O = 1, `=` = 2, H = 3)): could not find function "render.makesprite"

print(badger)
#> Error: object 'badger' not found
render.matrix(badger, palette = c(' ', 'O', 'H', '='))
#> Error in render.matrix(badger, palette = c(" ", "O", "H", "=")): could not find function "render.matrix"
```
