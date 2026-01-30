# Fonts

Fonts are used to draw text ingame with
[`render.text()`](https://gbkorr.github.io/rcade/reference/render.text.md).
A font is a list including `$sprites`, a list of sprites for each
character supported by the font.

really try/consider adding random demo photos all over the vignettes:
they (esp. inputs and render) are way too dense. even in render you
could replace some console examples with images All fonts are
monospaced.

## Usage

``` r
render.makefont(char_group = "uppercase", width, txt)
```

## Arguments

- char_group:

  Character group to make sprites for; see below.

- width:

  Desired width for each character.

- txt:

  String to turn into fonts. All nonspace characters will be converted
  to `1` in the sprites.

## Details

Fonts can have the following metadata:

|                 |     |                                                 |
|-----------------|-----|-------------------------------------------------|
|                 |     |                                                 |
| `$width`:       | ` ` | Width of each character in the font, in pixels. |
|                 |     |                                                 |
| `$height`:      |     | Height of each character in the font.           |
|                 |     |                                                 |
| `$kerning`:     |     | Default spacing between characters.             |
|                 |     |                                                 |
| `$linespacing`: |     | Default vertical spacing between lines of text. |
|                 |     |                                                 |
| `$sprites`:     |     | List of sprite matrices for each character.     |

## render.makefont()

`render.makefont()` is a convenient extension of
[`render.makesprite()`](https://gbkorr.github.io/rcade/reference/render.makesprite.md)
to create batches of characters at once. To use it, enter a string of
all characters in the `char_group` lined up horizontally (see examples).

The function does NOT create a full font object; it just generates some
of the `$sprites`.

The function returns a list with a sprite set for each character. The
sprites' widths must be set by `width`, while the height is determined
by the number of newlines in `txt` like in
[`render.makesprite()`](https://gbkorr.github.io/rcade/reference/render.makesprite.md).

The `char_group`s are as follows:

|              |     |                                            |
|--------------|-----|--------------------------------------------|
|              |     |                                            |
| `uppercase`: | ` ` | `abcdefghijklmnopqrstuvwxyz`               |
|              |     |                                            |
| `lowercase`: |     | `ABCDEFGHIJKLMNOPQRSTUVWXYZ`               |
|              |     |                                            |
| `numbers`:   |     | `0123456789`                               |
|              |     |                                            |
| `symbols`:   |     | `()[]{}<>+-*/=~.,:;'"``` ` ``\`!?@#\$%^&\_ |

Missing characters will be replaced with empty sprites of the
appropriate size.

## Preinstalled Fonts

The package comes with two fonts:
[fonts.3x3](https://gbkorr.github.io/rcade/reference/fonts.3x3.md) and
the more detailed
[fonts.3x5](https://gbkorr.github.io/rcade/reference/fonts.3x5.md).

## Examples

``` r
#used for `fonts.3x3`:
example_font = list(
  width = 3,
  height = 3,
  sprites = render.makefont('uppercase',width=3,'
 o  oo  ooo oo  ooo ooo  o  o o ooo ooo o o o   o o ooo ooo ooo  o  ooo  oo ooo o o o o o o o o o o oo
ooo ooo o   o o oo  oo  o   ooo  o   o  oo  o   ooo o o o o ooo o o oo   o   o  o o o o ooo  o   o   o
o o ooo ooo oo  ooo o   ooo o o ooo oo  o o ooo ooo o o ooo o    oo o o oo   o  ooo  o  ooo o o  o   oo
')
)
#> Error in render.makefont("uppercase", width = 3, "\n o  oo  ooo oo  ooo ooo  o  o o ooo ooo o o o   o o ooo ooo ooo  o  ooo  oo ooo o o o o o o o o o o oo\nooo ooo o   o o oo  oo  o   ooo  o   o  oo  o   ooo o o o o ooo o o oo   o   o  o o o o ooo  o   o   o\no o ooo ooo oo  ooo o   ooo o o ooo oo  o o ooo ooo o o ooo o    oo o o oo   o  ooo  o  ooo o o  o   oo\n"): could not find function "render.makefont"

render.matrix(cbind(
  example_font$sprites$H,
  matrix(0,3,1),
  example_font$sprites$I
))
#> Error in render.matrix(cbind(example_font$sprites$H, matrix(0, 3, 1),     example_font$sprites$I)): could not find function "render.matrix"
```
