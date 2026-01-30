# Resume Live Gameloop

The RAM needs several things to be set every time the gameloop starts:

- `RAM$time` needs to be set to the current
  [`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md)
  for the gameloop's timing to work properly (see
  [`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md)).

- `RAM$began` should be set to `c(time.sec(), RAM$ticks)` for inputs to
  be converted to the correct frame for processing (in
  [inputs.convert](https://gbkorr.github.io/rcade/reference/inputs.convert.md);
  see also
  [`vignette("inputs")`](https://gbkorr.github.io/rcade/articles/inputs.md))

## Usage

``` r
ram.resume(RAM, start_at = NULL)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init.md) object.

- start_at:

  Optional parameter to set the exact
  [`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md)
  when the RAM should start the gameloop; may be useful for syncing
  online play.
