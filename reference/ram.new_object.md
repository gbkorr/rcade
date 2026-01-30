# Add an Unnamed Object to RAM\$objects

Puts `object` into `RAM$objects` without assigning it a name. This is
useful when iteratively creating objects that will not be referenced by
name— see the `Snake` vignette for an example of this.

Otherwise, objects should be put in `RAM$objects` like so for easy
reference:

    RAM$objects$my_object = list(...)
    print(RAM$objects$my_object)

## Usage

``` r
ram.new_object(RAM, object)
```

## Arguments

- RAM:

  [RAM](https://gbkorr.github.io/rcade/reference/ram.init) object.

- object:

  Game object; a list with properties like `$x` and `$spritename`.

## Details

Convenience function for `RAM$objects = c(RAM$objects, list(object))`.
This is because the syntax for adding a nested list to a list is
`c(listA, list(listB))`!

Nested lists in R can be confusing, so it's better to have a function
that does this automatically than to trust users to remember the correct
syntax.
