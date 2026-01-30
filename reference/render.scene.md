# Render Scene to Console

Renders a scene object to the console by stacking its layers.  
Each layer is a matrix drawable by
[`render.matrix()`](https://gbkorr.github.io/rcade/reference/render.matrix.md),
and the layers are iteratively stacked with
[`render.overlay()`](https://gbkorr.github.io/rcade/reference/render.overlay.md).  
The highest layer is drawn on top.

## Usage

``` r
render.scene(scene, clear_console = FALSE, palette = c("  ", "[]", "  "))
```

## Arguments

- scene:

  Scene object to be rendered; see below.

- clear_console:

  Should the console be wiped before rendering the scene? This keeps the
  render in a consistent position.

- palette:

  An ordered vector of which character to draw when an element of M = 0,
  1, 2, 3, 4, etc. Typically this is ROM\$palette, which has the same
  default.

## Scene

The scene object has the following properties:

|           |     |                                                                                            |
|-----------|-----|--------------------------------------------------------------------------------------------|
|           |     |                                                                                            |
| `$width`  | ` ` | Width of scene in pixels. Should match `ROM$screen.width`.                                 |
|           |     |                                                                                            |
| `$height` |     | Height of scene in pixels. Should match `ROM$screen.height`.                               |
|           |     |                                                                                            |
| `$layers` |     | Ordered list of matrices representing each layer. All layers are of size `(width,height)`. |

## Inversion

The scene also has a `scene$layers$invert` layer; anything drawn to this
(e.g. with `render.sprite(...layer = 'invert')`) will
[invert](https://gbkorr.github.io/rcade/reference/render.overlay.md) the
colors of the rendered scene. This is useful for text.

## See Also

To render a sprite onto a scene layer,
[`render.sprite()`](https://gbkorr.github.io/rcade/reference/render.sprite.md)  
To render an object onto the scene,
[`render.object()`](https://gbkorr.github.io/rcade/reference/render.object.md)

The gameloop creates and renders the scene in
[`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md)

## Examples

``` r
#basic layering
scene = list(width=16, height=16)
box = matrix(c(1,1,1,1,1,1,2,2,2,1,1,2,2,2,1,1,2,2,2,1,1,1,1,1,1), ncol = 5)
for (i in 1:5) scene = render.sprite(scene, box, x=2*i, y=2*i, layer=6-i)
#> Error in render.sprite(scene, box, x = 2 * i, y = 2 * i, layer = 6 - i): could not find function "render.sprite"
render.scene(scene)
#> Error in render.scene(scene): could not find function "render.scene"

#inversion layer
bigbox = matrix(1,11,11)
scene = render.sprite(scene, bigbox, x=1, y=1, layer='invert')
#> Error in render.sprite(scene, bigbox, x = 1, y = 1, layer = "invert"): could not find function "render.sprite"
render.scene(scene)
#> Error in render.scene(scene): could not find function "render.scene"
```
