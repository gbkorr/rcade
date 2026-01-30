# Create ROM Object

A ROM object contains all the static data for running a game. ROM
elements can be set with this function or after the fact, e.g. with
`ROM$framerate = 30`.

See \`vignette("engine") for more info.

## Usage

``` r
rom.init(
  screen.width,
  screen.height,
  keybinds = c(w = "up", a = "left", s = "down", d = "right"),
  startup = function(RAM) {
     return(RAM)
 },
  custom = function(RAM) {
     return(RAM)
 },
  sprites = list(),
  palette = c("  ", "[]", "  "),
  framerate = 60,
  backup_duration = 2,
  input_delay = 1/60
)
```

## Arguments

- screen.width:

  Width of the game screen in pixels; see
  [render.scene](https://gbkorr.github.io/rcade/reference/render.scene.md).

- screen.height:

  Height of the game screen in pixels.

- keybinds:

  Vector of keys and their corresponding action; see
  [`inputs.process()`](https://gbkorr.github.io/rcade/reference/inputs.process.md).

- startup:

  Function run by the game when initialized with
  [`ram.init()`](https://gbkorr.github.io/rcade/reference/ram.init.md).
  Must return `RAM`.

- custom:

  Function run by the game on every frame with
  [`ram.tick()`](https://gbkorr.github.io/rcade/reference/ram.tick.md).
  Must return `RAM`.

- sprites:

  List of all sprites (matrices) used by the game; see
  [render.animate](https://gbkorr.github.io/rcade/reference/render.animate.md).

- palette:

  Vector of how each value of 0, 1, 2, 3, etc. in a sprite should be
  drawn by
  [`render.matrix()`](https://gbkorr.github.io/rcade/reference/render.matrix.md).

- framerate:

  Frames per second the game should run at. 60 recommended, 30 may be
  useful if
  [`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md)
  takes a significant amount of time.

- backup_duration:

  How frequently the RAM backs itself up in seconds; see
  [ram.rollback](https://gbkorr.github.io/rcade/reference/ram.rollback.md).
  Shouldn't need to be changed from the default.

- input_delay:

  Seconds to add to the timestamp of every input. Makes inputs get
  processed slightly after they were sent, to reduce the frequency of
  rollbacks.

## Game Code

`ROM$custom` updates the RAM every frame in
[`ram.tick()`](https://gbkorr.github.io/rcade/reference/ram.tick.md).
All game code should be either in `ROM$custom` or in helper functions
stored in the ROM, demonstrated below.

## Examples

``` r
testrom = rom.init(64,16)
#> Error in rom.init(64, 16): could not find function "rom.init"
testrom$example_function = function(){print('foo')}
#> Error: object 'testrom' not found
testrom$startup = function(RAM){RAM$ROM$example_function(); return(RAM)}
#> Error: object 'testrom' not found
RAM = ram.init(testrom)
#> Error in ram.init(testrom): could not find function "ram.init"
```
