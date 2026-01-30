# Get System Time as a Float

Grabs the absolute system time value from
[`base::Sys.time()`](https://rdrr.io/r/base/Sys.time.html). This is used
by the package to accurately time frames across instances and computers.

## Usage

``` r
time.sec()
```

## Value

A [double](https://rdrr.io/r/base/double.html) representing the seconds
since 1970 with sub-millisecond precision.

## Details

`= as.double(Sys.time())`

## Examples

``` r
print(time.sec(),digits=20)
#> Error in time.sec(): could not find function "time.sec"
```
