# Bad Apple

A ROM that plays the video [Bad
Apple](https://www.youtube.com/watch?v=FtutLA63Cp8).  
See `vignette("badapple")` for more details.

    RAM = ram.init(BadApple); RAM = ram.run(RAM)

You may have to zoom out a bit with `cmd -`.

`BadApple.data` stores the compressed video frames, which are
decompressed in `BadApple$startup()`.

## Usage

``` r
BadApple

BadApple.data
```

## Format

|            |     |                                                                       |
|------------|-----|-----------------------------------------------------------------------|
| `BadApple` | ` ` | A [ROM](https://gbkorr.github.io/rcade/reference/rom.init.md) object. |

|                 |     |                                                                                     |
|-----------------|-----|-------------------------------------------------------------------------------------|
| `BadApple.data` | ` ` | Compressed video frames; a list of vectors indicating which pixels flip each frame. |

## Details

This is a proof of concept for rendering video in rcade. It's actually
easier to render video by reading from a local file, but to fit a video
to come preinstalled with the package, I had to compress it.

`BadApple$startup()` reconstructs the video when the RAM is initialized,
saving the resultant frames as a single animation in `RAM$ROM$sprites`.
A single object then loops the animation constantly.

The frames are from <https://github.com/Timendus/chip-8-bad-apple>.

## Compression

`BadApple.data` is an ordered list of vectors, with each vector
corresponding to a frame. Each vector stores the indices of which pixels
should flip (`black <-> white`) compared the previous frame; this allows
the video to be iteratively reconstructed losslessly starting from a
blank frame.

Much stronger forms of compression have been devised for Bad Apple
projects, but this is a simple, naive approach that works well enough
(50 -\> 1MB) for the application. More importantly, rcade shouldn't
really require compressed videos since you can read frames directly from
a file.
