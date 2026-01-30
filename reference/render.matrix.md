# Render a Matrix to the Console

Prints a matrix as pixels: characters coded by the matrix.  
By default, this prints in black&white with black pixels represented as
`[]`:

        []
      []  []
    []      []
      [][][]

## Usage

``` r
render.matrix(M, clear_console = FALSE, palette = c("  ", "[]", "  "))
```

## Arguments

- M:

  Matrix to be drawn. Should contain only nonegative integers,
  corresponding to the desired characters to be drawn as defined by
  `palette`.

- clear_console:

  Wipes the console with `cat('\f')` before printing. This keeps the
  render in a consistent position.

- palette:

  An ordered vector of which character to draw when an element of M = 0,
  1, 2, 3, 4, etc.

## Default Palette

The default matrix-to-character encoding (palette) is as follows:

`0:`` ``: transparent`  
`1:`` [] ``: black`  
`2:`` ``: white`

White and Transparent are usually printed identically, but their
behavior differs elsewhere in the package. (i.e. when matrices are
overlaid with
[`render.overlay()`](https://gbkorr.github.io/rcade/reference/render.overlay.md))

## Examples

``` r
smiley = matrix(c(0,0,1,0,0,0,0,1,1,1,0,1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,0), ncol = 7)
print(smiley)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    1    0    1    0    0
#> [2,]    0    0    1    0    1    0    0
#> [3,]    1    0    0    0    0    0    1
#> [4,]    0    1    1    1    1    1    0
render.matrix(smiley)
#> Error in render.matrix(smiley): could not find function "render.matrix"

#ASCII art
badger = matrix(c(0,3,0,0,0,2,1,0,2,0,0,2,1,0,2,0,0,2,0,3,0), ncol = 7)
render.matrix(badger, palette = c(' ', 'O', 'H', '='))
#> Error in render.matrix(badger, palette = c(" ", "O", "H", "=")): could not find function "render.matrix"
```
