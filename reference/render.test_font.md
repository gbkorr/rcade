# Test a Font

Prints a large sampler of text using a font to see how it looks in
different contexts. You may have to zoom out with `cmd -` to see the
text render properly.

Alternatively, you can test fonts with something like
`render.matrix(render.text('example_text', font_to_test))`.

## Usage

``` r
render.test_font(font, verbose = FALSE)
```

## Arguments

- font:

  [Font](https://gbkorr.github.io/rcade/reference/render.makefont.md) to
  test.

- verbose:

  Boolean; print extra text samples?

## Details

Uses
[`render.text()`](https://gbkorr.github.io/rcade/reference/render.text.md)
to print the following:

1.  lowercase pangram

2.  uppercase pangram

3.  code sample

4.  all symbols

5.  all numbers

6.  lowercase alphabet

7.  uppercase alphabet

The alphabets are drawn last so they show up closest to the bottom of
the console. Each of the things printed are useful for different
purposes. If the font does not support some characters, the samples
containing them will be omitted. (e.g. uppercase-only fonts skip the
lowercase samples).

include a picture of `render.test_font(fonts.3x5)`

## Verbose

Use `verbose = TRUE` to print a few more samplers:

1.  mixed case phrase

2.  mixed cases and symbols

## Examples

``` r
render.test_font(fonts.3x5)
#> Error in render.test_font(fonts.3x5): could not find function "render.test_font"
```
