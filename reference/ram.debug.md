# Game Debug Info

YOU NEED TO ACTUALLY WRITE THIS FUNCTION (print out details about debug,
e.g. riollback frequency, average times, et.c) This function prints it
all, but it's recommended to plot separately (see examples).

## Usage

``` r
ram.debug(RAM)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object.

## Details

This function prints out some timing-related debug information.

`RAM$debug` contains a host of data from the RAM's recent gameplay,
relevant to the timing and rollback systems
([`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md)
and
[`vignette("rollback")`](https://gbkorr.github.io/rcade/articles/rollback.md)).
This is mostly useful for internal debugging (i.e. by the package dev),
especially for online play.

## RAM\$debug

`RAM$debug` contains the following elements:

|                |     |                                                                                                                                                                                                                                                |
|----------------|-----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                |     |                                                                                                                                                                                                                                                |
|                |     |                                                                                                                                                                                                                                                |
| `time`         |     | For each frame, [`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md) at the start of the frame. Useful as an x-axis for plotting other elements.                                                                               |
|                |     |                                                                                                                                                                                                                                                |
| `ahead`        |     | At the end of each frame, how far ahead the RAM is from the end of this frame; (`RAM$time - time.sec()`). If this is negative, the RAM is lagging behind.                                                                                      |
|                |     |                                                                                                                                                                                                                                                |
| `input.behind` | ` ` | For any inputs received on this frame, time between their timestamp and RAM\$time                                                                                                                                                              |
|                |     |                                                                                                                                                                                                                                                |
| `time.tick`    |     | For each frame, time it took to run [`ram.tick()`](https://gbkorr.github.io/rcade/reference/ram.tick.md).                                                                                                                                      |
|                |     |                                                                                                                                                                                                                                                |
| `time.draw`    |     | For each frame, time it took to run [`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md).                                                                                                                                  |
|                |     |                                                                                                                                                                                                                                                |
| `time.inputs`  |     | For each frame, time it took to run [`inputs.convert()`](https://gbkorr.github.io/rcade/reference/inputs.convert.md) and [`inputs.process()`](https://gbkorr.github.io/rcade/reference/inputs.process.md).                                     |
|                |     |                                                                                                                                                                                                                                                |
| `rollbacks`    |     | For each occurrence of a rollback ([`ram.rollback()`](https://gbkorr.github.io/rcade/reference/ram.rollback.md) call), records the [`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md) at which it happened.                  |
|                |     |                                                                                                                                                                                                                                                |
| `frames`       |     | For each frame, the value of `RAM$ticks`; the current tick the RAM is at. Makes rollbacks a more obvious than buffer.                                                                                                                          |
|                |     |                                                                                                                                                                                                                                                |
| `frames.drawn` |     | Records every frame of `RAM$ticks` that was drawn by [`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md), i.e. when `ahead` was positive (see [`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md)). |

## Examples

``` r
if (FALSE) { # \dontrun{
#plot buffer over time to see rollbacks
plot(RAM$debug$time, RAM$debug$buffer, type='l')

#compare which parts of each frame took up the most time
plot(rowSums(cbind(
  RAM$debug$time.tick,
  RAM$debug$time.inputs,
  RAM$debug$time.draw
),na.rm=TRUE), type='l')
lines(RAM$debug$time.tick, col='blue')
lines(RAM$debug$time.draw, col='red')
lines(RAM$debug$time.inputs, col='green')
} # }
```
