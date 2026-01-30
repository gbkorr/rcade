# Sprite Animations

Retrieves the current frame from a sprite animation. todo examples

## Usage

``` r
render.animate(spritename, timer, sprites, render_framerate = 60)
```

## Arguments

- spritename:

  String; name of sprite as defined in `sprites`.

- timer:

  Number of ticks elapsed since the animation started.

- sprites:

  `RAM$ROM$sprites`; list of sprites.

- render_framerate:

  `RAM$ROM$framerate`; game framerate.

## Value

Returns a sprite matrix suitable for
[`render.sprite()`](https://gbkorr.github.io/rcade/reference/render.sprite.md).

## Details

A sprite defined in `ROM$sprites` can either be *simple* or *complex*;

Simple sprites are just a static sprite matrix.

Complex sprites are a list containing multiple frames of animation.
Complex sprites can have the following properties:

|                   |     |                                                                                                                                   |                                           |
|-------------------|-----|-----------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
|                   |     |                                                                                                                                   |                                           |
| `$framerate`      | ` ` |                                                                                                                                   | Framerate at which to play the animation. |
|                   |     |                                                                                                                                   |                                           |
| `$next_animation` |     | spritename of which animation from ROM\$sprites to play next when all frames of this one have played. If `NULL`, animation loops. |                                           |
|                   |     |                                                                                                                                   |                                           |
| `$frames`         |     | list of sprite matrices (simple sprites).                                                                                         |                                           |
|                   |     |                                                                                                                                   |                                           |
| `$offset.x`       |     | Offsets the location at which the sprite is drawn; see [render.object](https://gbkorr.github.io/rcade/reference/render.object.md) |                                           |
|                   |     |                                                                                                                                   |                                           |
| `$offset.y`       |     | Offset relative to y.                                                                                                             |                                           |

Animated sprites can be tested using
[`render.test_animation()`](https://gbkorr.github.io/rcade/reference/render.test_animation.md).

## Examples

``` r
#simple two-part animation using sprite$next_animation
```
