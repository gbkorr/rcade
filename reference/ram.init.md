# Create RAM Object

Uses a game ROM object to create a RAM object, which stores all dynamic
data of the game. As
[`ram.run()`](https://gbkorr.github.io/rcade/reference/ram.run.md) runs
the game, the RAM is updated and read.

## Usage

``` r
ram.init(ROM)
```

## Arguments

- ROM:

  [ROM](https://gbkorr.github.io/rcade/reference/rom.init.md) object
  containing game code.

## Value

A RAM object contains the following elements.

|                |     |                                                                                                                                                                                                                                   |
|----------------|-----|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                |     |                                                                                                                                                                                                                                   |
| `ROM`          | ` ` | ROM object the game is run with.                                                                                                                                                                                                  |
|                |     |                                                                                                                                                                                                                                   |
| `ticks`        |     | Number of frames the game has processed.                                                                                                                                                                                          |
|                |     |                                                                                                                                                                                                                                   |
| `time`         |     | Time of the latest frame reached by the RAM.                                                                                                                                                                                      |
|                |     |                                                                                                                                                                                                                                   |
| `rng`          |     | WRITEHERE see [ram.set_rng](https://gbkorr.github.io/rcade/reference/ram.set_rng.md)                                                                                                                                              |
|                |     |                                                                                                                                                                                                                                   |
| `seed`         |     | Integer used to [set the rng](https://rdrr.io/r/base/Random.html) during ram.init. Random by default.                                                                                                                             |
|                |     |                                                                                                                                                                                                                                   |
| `objects`      |     | List of game-related objects; dynamic game data should generally be stored here. Objects in this list which have a `$spritename` are drawn in [`render.ram()`](https://gbkorr.github.io/rcade/reference/render.ram.md).           |
|                |     |                                                                                                                                                                                                                                   |
| `inputs`       |     | List of all inputs the game has received, matching `inputs.csv`. See [`inputs.process()`](https://gbkorr.github.io/rcade/reference/inputs.process.md).                                                                            |
|                |     |                                                                                                                                                                                                                                   |
| `actions`      |     | List of all game actions that are currently active                                                                                                                                                                                |
|                |     |                                                                                                                                                                                                                                   |
| `n_inputs`     |     | Number of inputs from `inputs.csv` the RAM has read. Used to determine which are new.                                                                                                                                             |
|                |     |                                                                                                                                                                                                                                   |
| `backup`       |     | Copy of RAM from a couple seconds ago, excluding `$ROM`, `$inputs`, `$debug`, `$backup`, and `$intermediate` (since these shouldn't be rolled back). See [ram.rollback](https://gbkorr.github.io/rcade/reference/ram.rollback.md) |
|                |     |                                                                                                                                                                                                                                   |
| `intermediate` |     | Same as `$backup`, but more recent. Used in [`ram.tick()`](https://gbkorr.github.io/rcade/reference/ram.tick.md) to update `$backup` on a rolling basis.                                                                          |
|                |     |                                                                                                                                                                                                                                   |
| `began`        |     | Vector of c(time,tick) indicating when [ram.run](https://gbkorr.github.io/rcade/reference/ram.run.md) was last run, used for timing inputs.                                                                                       |
|                |     |                                                                                                                                                                                                                                   |
| `paused`       |     | Boolean; is the game allowed to tick?                                                                                                                                                                                             |
|                |     |                                                                                                                                                                                                                                   |
| `debug`        |     | Collection of info about the current game session; see [ram.debug](https://gbkorr.github.io/rcade/reference/ram.debug.md).                                                                                                        |

## Notes

Custom game code (in
[`RAM$ROM$custom`](https://gbkorr.github.io/rcade/reference/rom.init.md))
should typically only modify `RAM$objects`. This makes inspecting and
handling the RAM more consistent across games.
