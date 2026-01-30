# Temporal RAM Position

Returns how far, in seconds, the RAM is 'ahead' of the System time. Used
for convenience in
[`ram.update()`](https://gbkorr.github.io/rcade/reference/ram.update.md).

See
[`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md)
for more info; the x-axis of the diagrams are `time.ram()`.

## Usage

``` r
time.ram()
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object.

## Details

`= RAM$time - time.sec()`
