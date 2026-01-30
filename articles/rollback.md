# Rollback in the rcade Engine

This article provides a description of why, when, and how the game rolls
back to stay in sync with inputs. This system isn’t that relevant for
the current iteration of rcade, but I might rewrite the article when I
add online play.

## 1. Overview

Suppose two players are playing a game online. Their computers are
exchanging information about what buttons they’re pressing to keep both
their games in sync.

But now, one of the players’ internet falters for a second. That player
tries to jump; but by the time their computer sends “player 1 jumped” to
the other player, *it’s been a whole second since they tried to jump*.
Now what!? We can’t just keep running the game, or totally different
things would happen on the players’ screens.

The traditional workaround was to make this scenario impossible by
pausing *both* players’ games any time internet lag occurred. The
problem: pausing games randomly makes for an awful, choppy experience!

So modern games use a different solution, that never pauses or
interrupts the game. When a game realizes something was **received
late** like this, the game engine *rewinds the game* to before the input
happened, and then fast-forwards it back to the present, repeating any
inputs that should have happened. This is called a **rollback**.

This technique creates a smooth experience that solves our problem. It
has a few limitations[¹](#fn1), but it’s usually much better than the
old solution.

### 1.1 Online?

“Wait a minute. Playing online? rcade doesn’t do online!”

But it’s designed to! And sometime, I’ll make an addon package that lets
you do it.

The rollback system isn’t really relevant for singleplayer games. I
built it into the engine because:

1.  It’s good practice and makes for a more robust engine.

2.  It makes the engine *easily* extendable to multiplayer.

3.  I was as little worried that reading from the `inputs.csv` file
    might take too long for inputs to feel snappy. Luckily, it’s as
    instantaneous as everything else.

So, rcade structures itself in a way that makes rollbacks convenient and
effective. How?

## 2. Rolling Back

We’ve just received an input that was supposed to have already happened.
To resolve this, all we have to do is restore a previous gamestate, and
rerun the game back to the present! This will process the input at the
correct time now that we have it.

Functionality to restore a previous version is baked into the engine.
The RAM continually refreshes[²](#fn2) a copy of itself from 2 seconds
prior[³](#fn3) to use for this purpose.

This copy is restored with
[`ram.rollback()`](https://gbkorr.github.io/rcade/reference/ram.rollback.md),
which just calls
[`utils::modifyList`](https://rdrr.io/r/utils/modifyList.html) to
overwrite the RAM with values from its backup.

Once this version is restored, the game is two seconds or so behind the
present. Luckily, the timing system (explained in detail in
[`vignette("timing")`](https://gbkorr.github.io/rcade/articles/timing.md))
automatically deals with this situation by catching it up to the present
as quickly as possible. As it catches up, inputs are reapplied when they
should have occurred.

All of this works because inputs are stored in one
dataframe—`RAM$inputs` (which isn’t rolled back)—and the game only cares
about what inputs correspond to the current frame of RAM.

See
[`vignette("inputs")`](https://gbkorr.github.io/rcade/articles/inputs.md)
or
[`?inputs.process`](https://gbkorr.github.io/rcade/reference/inputs.process.md)
for more details on the Input system.

## 3. RNG

The RAM stores its own RNG just like an R session. Backups restore RNG
state, so rollbacks will experience the same random events that happened
originally, as you’d expect.

The RAM RNG can be set manually with
[`ram.set_rng()`](https://gbkorr.github.io/rcade/reference/ram.set_rng.md).

------------------------------------------------------------------------

1.  Which are very much out of the scope of this package, and not all
    that impactful anyway.

2.  See the Backups section of
    [`?ram.rollback`](https://gbkorr.github.io/rcade/reference/ram.rollback.md).

3.  `RAM$ROM$backup_duration` seconds, which defaults to 2 (and changing
    isn’t recommended).
