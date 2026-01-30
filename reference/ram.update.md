# Gameloop

Ticks RAM, draws RAM, and syncs time with the framerate.  
This function is looped infinitely by
[`ram.run()`](https://gbkorr.github.io/rcade/reference/ram.run.md); it
should not be used alone.

## Usage

``` r
ram.update(RAM)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object to
  update.

## Details

If the RAM is behind the current frame (lagging)
(`RAM%time < `[`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md)):

- drawing is skipped

- `ram.update()` is called again with no delay

If the RAM is ahead of the current frame (caught up):

- [`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md)
  is called to draw the game

- the game sleeps until the next frame

This tries to keep the RAM on the current frame, such that it will
always be ahead (and have time to draw).  
When the RAM is behind the current frame, the game update process speeds
up and runs the game as fast as possible without any drawing to get it
back to the current time.  

Since drawing is by far the slowest part of the gameloop, this allows it
to recover and catch up to the present very quickly after time is
rewound in a
[rollback](https://gbkorr.github.io/rcade/reference/ram.rollback.md).
