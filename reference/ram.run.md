# Main Gameloop

`ram.run()` runs the main gameloop, continuously ticking and drawing.

The game can be paused with `^C`, and will resume when `ram.run()` is
called again.

## Usage

``` r
ram.run(RAM, start_at = NULL)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object to
  run.

- start_at:

  RAM will wait until
  [`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md)`==`
  this value to start running. If `NULL`, RAM starts running
  immediately. This argument is used to sync multiplayer sessions and
  otherwise doesn't matter.

## Details

This function runs the following code and returns the RAM upon
interruption by ^C or error.

    while(TRUE) RAM = ram.update(RAM)

The function will also print a full traceback if it encounters an error.

## Function Tree

Functions are nested in the gameloop like so:

`ram.run()`  
` `[`ram.update()`](https://gbkorr.github.io/rcade/reference/ram.update.md)
every frame (see
[`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md))  
` `[`inputs.get()`](https://gbkorr.github.io/rcade/reference/inputs.get.md)  
` `[`inputs.read()`](https://gbkorr.github.io/rcade/reference/inputs.listen.md)  
` `[`inputs.command()`](https://gbkorr.github.io/rcade/reference/inputs.command.md)
if any commands are sent  
` ``inputs.rollback()` if any inputs were received late  
` `[`inputs.process()`](https://gbkorr.github.io/rcade/reference/inputs.process.md)  
` `[`ram.tick()`](https://gbkorr.github.io/rcade/reference/ram.tick.md)  
` ``RAM$ROM$custom()`  
` `[`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md)
if
`RAM$time > `[`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md)  
` `[`render.object()`](https://gbkorr.github.io/rcade/reference/render.object.md)
for every object in `RAM$objects`  
` `[`render.animate()`](https://gbkorr.github.io/rcade/reference/render.animate.md)
if the object has a [complex
sprite](https://gbkorr.github.io/rcade/reference/render.animate.md)  
` `[`render.sprite()`](https://gbkorr.github.io/rcade/reference/render.sprite.md)
or custom `obj$draw()`  
` `[`render.overlay()`](https://gbkorr.github.io/rcade/reference/render.overlay.md)  
` `[`render.scene()`](https://gbkorr.github.io/rcade/reference/render.scene.md)  
` `[`render.overlay()`](https://gbkorr.github.io/rcade/reference/render.overlay.md)
for every layer in `scene$layers`  
` `[`render.matrix()`](https://gbkorr.github.io/rcade/reference/render.matrix.md)
