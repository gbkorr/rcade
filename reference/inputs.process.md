# Apply Inputs

Updates `RAM$actions` according to any inputs occurring on the current
frame.

Inputs and actions are stored in RAM like so:

|               |     |                                                                                                                        |
|---------------|-----|------------------------------------------------------------------------------------------------------------------------|
|               |     |                                                                                                                        |
| `RAM$inputs`  | ` ` | Stores every input that ever occurred, just like [`inputs.csv`](https://gbkorr.github.io/rcade/reference/inputs.read). |
|               |     |                                                                                                                        |
| `RAM$actions` |     | Stores the game actions corresponding to inputs as dictated in `ROM$keybinds` (see below).                             |

## Usage

``` r
inputs.process(RAM)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object to
  update.

## Details

The following is an outline of the process from a player entering an
input to it being registered by the game.

1.  Player types out "wa" in the
    [`inputs.listen()`](https://gbkorr.github.io/rcade/reference/inputs.listen.md)
    listener.  

2.  Player presses Enter; an input is created consisting of the string
    `"wa"` and a timestamp (see
    [inputs.listen](https://gbkorr.github.io/rcade/reference/inputs.listen.md)).  
    This input is written to
    [`inputs.csv`](https://gbkorr.github.io/rcade/reference/inputs.read).  

3.  When the gameloop runs
    [`inputs.get()`](https://gbkorr.github.io/rcade/reference/inputs.get.md),
    this input is added to `RAM$inputs` and its timestamp is converted
    to the tick it should be processed on.  

4.  When `RAM$ticks ==` the tick timestamp of this input in
    `RAM$inputs`, the input is processed:  

5.  The input is split into individual characters: `"w"` and `"a"`.  

6.  The actions corresponding to these keys,
    `RAM$ROM$keybinds["w"] and RAM$ROM$keybinds["a"]`, are set to `TRUE`
    in `RAM$actions` (see below).  

7.  Game code in `RAM$ROM$custom()` reads `RAM$actions` and move the
    player character accordingly.

8.  On the next frame, all `RAM$actions` are set to FALSE before inputs
    are checked again.

## Keybinds

Keybinds are set by the dev with, e.g.

    ROM$keybinds = c(k = 'attack', w = 'up', a = 'left', s = 'down', d = 'right')

This stores the actions ('attack', 'up', etc.) and the keys (k, w, etc.)
that, when input, activate the actions. These keybinds populate
`RAM$actions` when RAM is
[initialized](https://gbkorr.github.io/rcade/reference/ram.init):

    RAM$actions = c(attack = FALSE, up = FALSE, left = FALSE, down = FALSE. right = FALSE)

When a key is registered, the corresponding action in `RAM$actions` is
set to TRUE for one frame.

The game should read RAM\$actions to control game behavior; see
`vignette('rrio')` to see this in action.
