# Record Player Inputs

`inputs.listen()` listens for input and writes all entered text into the
`inputs.csv` file in the package directory.

`inputs.listen()` should be run in a **separate RStudio instance** from
where the game is running. This allows the game to read player input
without interruption.

`inputs.read()` reads this `inputs.csv` file; it is called in the [main
gameloop](https://gbkorr.github.io/rcade/reference/ram.update.md) to
retrieve live player input.

Each input is only submitted when the `Enter` key is pressed. This can
make interacting with the game initially challenging.

## Usage

``` r
inputs.listen()

inputs.read()
```

## Details

An 'input' is a string of text with a timestamp corresponding to when
the game should
[process](https://gbkorr.github.io/rcade/reference/inputs.process.md)
the input.

Inputs are stored as rows in the `inputs.csv` dataframe, which has the
following columns:

|             |     |                                                                                                                                         |
|-------------|-----|-----------------------------------------------------------------------------------------------------------------------------------------|
|             |     |                                                                                                                                         |
| `timestamp` | ` ` | [`time.sec()`](https://gbkorr.github.io/rcade/reference/time.sec.md) at which the input was entered plus a small delay (see arguments). |
|             |     |                                                                                                                                         |
| `text`      |     | String that was entered at this timestamp. Each character will be parsed by the game as an individual key input.                        |

`inputs.listen()` adds a new row to `inputs.csv` each time `Enter` is
pressed.

## inputs.csv

`inputs.csv` is stored in `tools::R_user_dir('rcade')`, the directory
for storing package data.

Only one `inputs.csv` file exists and is read by the package; the file
is wiped every time
[`ram.init()`](https://gbkorr.github.io/rcade/reference/ram.init.md) is
called.

## See also

[`vignette("inputs")`](https://gbkorr.github.io/rcade/articles/inputs.md)
gives an overview of each part of the input system.

[?inputs.process](https://gbkorr.github.io/rcade/reference/inputs.process.md)
provides a more focused description of how an input gets from the
player's keyboard to the game code.
