# Set RAM RNG

Sets the RAM's RNG with
[`base::set.seed()`](https://rdrr.io/r/base/Random.html). This is useful
in `ROM$startup` if a dev wants their game to always use the same RNG
seed, etc.

## Usage

``` r
ram.set_rng(RAM, seed)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object.

- seed:

  Integer used for [base::set.seed](https://rdrr.io/r/base/Random.html).

## Details

R's RNG is based on the .Random.seed global variable, which updates when
a random call or set.seed() is called. RAM stores its own copy of this
variable and temporarily restores it before running game code. Thus RNG
ends up working as expected within a game, and will produce the same
random calls when the game rolls back.

Additionally, the RAM restores the R session's RNG after running game
code, so the user's R environment is unaffected by random calls in the
game.
