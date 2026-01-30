# Execute a Rollback

Restores the RAM state from several seconds ago.
[`ram.update()`](https://gbkorr.github.io/rcade/reference/ram.update.md)
will then rapidly advance the game to catch up with the current time.

This is usually triggered by
[`inputs.read()`](https://gbkorr.github.io/rcade/reference/inputs.listen.md)
upon registering an input that was supposed to have happened, but didn't
because it was received late. To prevent the input from being dropped,
the game rolls back and reruns the past few seconds to rectify the
mistake.

## Usage

``` r
ram.rollback(RAM)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object.

## Backups

RAM always keeps a backup of itself saved in RAM\$backup, containing the
entire RAM from the time of the backup minus inputs, debug info, and the
ROM; these are never rolled back.

Backups have a minimum age of `RAM$ROM$backup_duration`; the RAM can
only be restored to around that time ago. Backups are saved during
[`ram.tick()`](https://gbkorr.github.io/rcade/reference/ram.tick.md).

RAM\$intermediate is used to store the next backup before it replaces
the current one, to ensure that backups are never younger than
`RAM$ROM$backup_duration`.

## Rollback

This function just restores RAM\$backup with

    RAM = utils::modifyList(RAM, RAM$backup)

Since this puts RAM\$time behind, the gameloop automatically speeds up
to catch the RAM back up.

This catchup process runs the inputs again, so if any inputs were
received late, they will now be registered on time.
