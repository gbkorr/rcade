# Manually Add an Input to RAM

Allows the user to input to RAM while RAM is not being run.

## Usage

``` r
ram.input(RAM, input, timestamp = NULL)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init.md) object.

- input:

  Input to add to RAM\$inputs. Exactly what you might type in the input
  session.

- timestamp:

  Specific tick set the input for. `NULL` sets the input to be processed
  on the next tick.

## Details

Adds an input to `RAM$inputs` as if it were a new input in `inputs.csv`.
The input is set to occur on the next tick unless specified by
`timestamp`.
