# Backup RAM

Creates a backup of RAM. This is different from a full copy (e.g.
`my_copy = RAM`):

|        |     |                                                                                                                                      |
|--------|-----|--------------------------------------------------------------------------------------------------------------------------------------|
|        |     |                                                                                                                                      |
| Copy   | ` ` | A full copy of the RAM; this will restore the full state of the RAM, deleting any inputs or debug info that may have happened since. |
|        |     |                                                                                                                                      |
| Backup |     | A backup of most RAM data, but excluding inputs and debug information; these will be preserved if the backup is restored.            |

## Usage

``` r
ram.backup(RAM)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object.

## Value

RAM, minus `$ROM, $inputs, $debug, $intermediate, $backup,` and
`$paused`.  
This output is stored in the main RAM's `$intermediate` and `$backup`.

## Details

The game uses this to periodically back up the gamestate so that it can
restore it in a
[rollback](https://gbkorr.github.io/rcade/reference/ram.rollback.md).
