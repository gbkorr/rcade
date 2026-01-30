# Ingame Commands

Allow the user to interact with the RAM from the listening session by
inputting `/[command]` during listening.

See `vignette("rrio")` to see these in action.

## Usage

``` r
inputs.command(RAM, command)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init.md) object.

- command:

  Command to use; parsed from `inputs.csv`.

## Details

These commands are generally useful to debugging or testing parts of a
game that are difficult to test at full speed. Alternatively, greater
control can be achieved by using the display session and manually
interacting with the game with:

    RAM = ram.input(RAM, [input])
    RAM = ram.tick(RAM)
    render.ram(RAM)

Which also allows the user to copy and restore RAMs as savestates, etc.

## Commands

|             |     |                                                                                                                                               |
|-------------|-----|-----------------------------------------------------------------------------------------------------------------------------------------------|
|             |     |                                                                                                                                               |
| `/pause`    |     | Pauses the RAM without stopping the gameloop.                                                                                                 |
|             |     |                                                                                                                                               |
| `/resume`   |     | Resumes the game if paused.                                                                                                                   |
|             |     |                                                                                                                                               |
| `/tick`     |     | Iterates the RAM one tick, as if [`ram.tick()`](https://gbkorr.github.io/rcade/reference/ram.tick.md) had been called in the display session. |
|             |     |                                                                                                                                               |
| `/rollback` |     | Forces a rollback, and draws if the game is paused.                                                                                           |

If the game is paused and an input is entered, it will be processed next
`/tick` or when the game resumes. This allows the player to play a game
frame-by-frame.
