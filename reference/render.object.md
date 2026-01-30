# Draw an Object to the Scene

Calls
[`render.sprite()`](https://gbkorr.github.io/rcade/reference/render.sprite.md)
using an object's `$spritename` (the name of the desired sprite in
`RAM$ROM$sprites`).

The object is drawn at position `(obj$x, obj$y)` on layer `obj$layer` if
specified (see below).

Objects with no `$spritename` will not be drawn, unless they have custom
drawing behavior defined in `obj$draw()`:

If the object has a function set for `obj$draw()`, it will be run
instead of
[`render.sprite()`](https://gbkorr.github.io/rcade/reference/render.sprite.md).
This allows the game dev to create custom drawing behavior.

    scene = obj$draw(scene, obj, RAM)

## Usage

``` r
render.object(scene, obj, RAM)
```

## Arguments

- scene:

  [Scene](https://gbkorr.github.io/rcade/reference/render.scene.md)
  object.

- obj:

  Object in `RAM$objects`. Objects with a `$spritename` will be drawn.

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init.md) object.

## Value

Returns the
[scene](https://gbkorr.github.io/rcade/reference/render.scene.md) object
with sprite drawn. This function is called by
[`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md)
for each object in `RAM$objects`.

## Details

An object only needs a `$spritename` to be drawn. Objects can also have
the following properties which influence how they're drawn: otherwise,
the default value (second column) will be used.

|               |     |                |                                                                                                                                                |
|---------------|-----|----------------|------------------------------------------------------------------------------------------------------------------------------------------------|
|               |     |                |                                                                                                                                                |
| `$spritename` |     |                | Name of sprite in `ROM$sprites`.                                                                                                               |
|               |     |                |                                                                                                                                                |
| `$x`          | ` ` | `1`            | X-coordinate at which to draw the object's sprite in the scene.                                                                                |
|               |     |                |                                                                                                                                                |
| `$y`          |     | `1`            | Y-coordinate.                                                                                                                                  |
|               |     |                |                                                                                                                                                |
| `$layer`      |     | `2`            | Layer on which to draw the sprite. See [render.scene](https://gbkorr.github.io/rcade/reference/render.scene.md); high layers are drawn on top. |
|               |     |                |                                                                                                                                                |
| `$timer`      |     | `RAM$timer`` ` | Tick count (ascending) for animations.                                                                                                         |
|               |     |                |                                                                                                                                                |
| `$palette`    |     | `NULL`         | Vector to swap the colors of the object's sprite around, e.g. `c(0,2,1)` swaps values of 2 and 1. Index starts at 0. Defaults to no swapping.  |
|               |     |                |                                                                                                                                                |
| `$draw()`     |     | `NULL`         | Overwrites the default drawing behavior for the sprite; see above.                                                                             |
