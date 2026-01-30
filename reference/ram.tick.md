# Tickstep RAM

Runs one tick (frame) of the RAM. This means calling `RAM$ROM$custom()`
once (see
[rom.init](https://gbkorr.github.io/rcade/reference/rom.init.md)).

## Usage

``` r
ram.tick(RAM)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object to
  update.

## Value

The following happens to the RAM object:

- `RAM$ticks` increases by one.  
  (a new tick has occurred)

- `RAM$time` increases by 1/framerate.  
  (the RAM is now one frame further in time)

- `RAM = RAM$ROM$custom(RAM)` is run.  
  (the game code is run once on the RAM)  

- `RAM$backup` is occasionally updated; see
  [ram.rollback](https://gbkorr.github.io/rcade/reference/ram.rollback.md).  
  (the game is occasionally backed up)
