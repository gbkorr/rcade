# Draw the RAM

Draws RAM at the current tick by drawing each object in `RAM$objects`
that has a sprite.

## Usage

``` r
render.ram(RAM, clear_console = FALSE)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object to
  draw.

- clear_console:

  Should the console be wiped before rendering the scene? This keeps the
  render in a consistent position.

## Details

This creates a scene object with size
`(RAM$ROM$screen.width, RAM$ROM$screen.height)`,  
calls
[`render.object()`](https://gbkorr.github.io/rcade/reference/render.object.md)
on every object to draw them onto this scene,  
and then calls
[`render.scene()`](https://gbkorr.github.io/rcade/reference/render.scene.md).
