# Common Issues

Unexpected crash? This documentation provides debugging resources and
lists some common problems you might encounter.

The Snake vignette is goes through the basic development process and is
very useful; you can view it with `vignette("Snake")`.

## Usage

``` r
rom.help()

ram.help()
```

## Traceback

When the game crashes, it prints a `traceback, call, and error`:

|           |     |                                                                                                                                                                   |
|-----------|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|           |     |                                                                                                                                                                   |
| Traceback | ` ` | A list showing which functions led to where the error is. Should be similar to what you get from base R's [`traceback()`](https://rdrr.io/r/base/traceback.html). |
| Call      |     | The call in which the error occurred.                                                                                                                             |
| Error     |     | The specific error.                                                                                                                                               |

[`?ram.run`](https://gbkorr.github.io/rcade/reference/ram.run.md) has a
function tree of that may be useful in understanding where an error
occurred; the traceback will list the branches encompassing the error
call.

## Logging

Multiple options exist for printing information via game code.

- The contents of `RAM$echo` are printed below the game render every
  frame.

- Any [`base::print()`](https://rdrr.io/r/base/print.html) calls will
  only be visible *if the game crashes* due to how the console is wiped.

- A global variable `foo <<- [debug info]` can be modified via the game
  code.

Thus [`print()`](https://rdrr.io/r/base/print.html) is ideal for
debugging the source of a crash, as it prints information about the
current tick. `RAM$echo` is useful for monitoring values while running
the game, and using a global variable gives more control and the option
to record info for every tick.

## Timing

[RAM\$debug](https://gbkorr.github.io/rcade/reference/ram.debug.md)
records a lot of timing-related data relevant to the timing and rollback
systems
([`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md)
and
[`vignette("rollback")`](https://gbkorr.github.io/rcade/articles/rollback.md)).

## Empty Lists

Make sure you haven't accidentally wiped RAM or `RAM$objects`. This can
happen if you define a custom function like `ROM$my_function(RAM)` and
forget to return RAM at the end of it.

## Inputs

Make sure that `tools::R_user_dir("rcade")` exists.

Double-check `ROM$keybinds` and make sure `RAM$actions` are properly
referenced in your code. Consider adding `RAM$echo = RAM$actions` to
`ROM$custom` to show the state of each action every tick.

## Iterating

To iterate through `RAM$objects`, use the syntax

    for (i in 1:length(RAM$objects)){
        obj = RAM$objects[[i]]

    }

This is required due to how R handles nested lists; the format  
`for (obj in RAM$objects)` will **NOT** work.
