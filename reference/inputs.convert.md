# Read Inputs with RAM

Retrieves new inputs with
[`inputs.read()`](https://gbkorr.github.io/rcade/reference/inputs.listen.md),
converts their timestamp to the tick the game should process them on,
and saves them to `RAM$inputs`.  
If any of these new inputs should have occurred on a prior tick, [rolls
back](https://gbkorr.github.io/rcade/reference/ram.rollback) to resolve
the dropped input.

See
[`vignette("inputs")`](https://gbkorr.github.io/rcade/articles/inputs.md)
for more details.

## Usage

``` r
inputs.convert(RAM)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object to
  update.

## Details

New inputs are inputs which exist in `inputs.csv` but not in
`RAM$inputs`.

The tick an input should occur on is calculated as:

    RAM$began[2] +
    ceiling(
        RAM$ROM$framerate * (
                newinputs$timestamp +
                RAM$ROM$input_delay -
                RAM$began[1]
        )
    )

Where `RAM$began` stores the `c(timestamp, tick)` of the last time
[`ram.run()`](https://gbkorr.github.io/rcade/reference/ram.run.md) was
called, `ROM$input_delay` is the desired delay between inputting a key
and when the game should register it, and `ROM$framerate` is the desired
framerate of the game.

New inputs occurring before the last call of ram.run, i.e. those from
before the game started or while the game was paused, have their tick
set to `-1` so they will never be registered.

Then `RAM$inputs` is updated to contain all the new inputs, matching
`inputs.csv`.
