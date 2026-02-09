# Stop the Gameloop

Exits [`ram.run()`](https://gbkorr.github.io/rcade/reference/ram.run.md)
without printing an error traceback; the code equivalent of `^C`. This
function is intended to be run in custom Game Code.

## Usage

``` r
ram.end()
```

## Details

Useful for Game Over scenarios, etc; see its usage in
[`vignette("snake")`](https://gbkorr.github.io/rcade/articles/snake.md).

## Examples

``` r
print(Snake$end_game)
#> function(RAM){
#>  cat('Game over! Size: ',
#>          RAM$segments,
#>          '. Time survived: ',
#>          RAM$ticks_survived,
#>          '.',
#>          sep='')
#> 
#>  RAM$ROM$view_data(RAM)
#> 
#>  ram.end() #stops the game
#> }
```
