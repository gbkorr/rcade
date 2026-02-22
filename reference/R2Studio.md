# R^2Studio

RStudio in RStudio! Type R code into the input session to execute it in
a simulated R console.

See
[`vignette("r2studio")`](https://gbkorr.github.io/rcade/articles/r2studio.md)
for details on the ROM's inner workings.

## Usage

``` r
R2Studio
```

## Format

A game [ROM](https://gbkorr.github.io/rcade/reference/rom.init.md); see
[`vignette("engine")`](https://gbkorr.github.io/rcade/articles/engine.md).

## Details

To start, run `quickload(R2Studio)` and start the input session with
[`inputs.listen()`](https://gbkorr.github.io/rcade/reference/inputs.listen.md)
in a separate RStudio window (as usual).

Now, any text entered in the input session will be interpreted as R code
in the R\\^2\\Studio console. You should be able to run text-based code
as you would in the regular IDE!

## Plotting

Entering a `plot` command will draw the plot inside the game display.
All other plotting commands are unsupported.

R²Studio's scatterplots respect several parameters from
[`base::plot()`](https://rdrr.io/r/base/plot.html):

    x
    y
    xlim
    ylim
    main
    pch
    cex

## Settings

The appearance of the console can be changed with a couple commands
(entered in the input session like any other code for R\\^2\\Studio).

`use.size(width = NULL, height = NULL, plot.width = NULL)`: resize
display or plot window

`use.font(font = NULL, kerning = NULL, linespacing = NULL, darkmode = NULL)`:
change or edit console font
