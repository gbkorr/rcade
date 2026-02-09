# Render Text as Sprite

Generates a sprite for a block of text, suitable for drawing with
[render.matrix](https://gbkorr.github.io/rcade/reference/render.matrix.md).

## Usage

``` r
render.text(
  str,
  font = rcade::fonts.3x3,
  wrap = FALSE,
  kerning = NULL,
  linespacing = NULL,
  alignment = "left"
)
```

## Arguments

- str:

  String to make a sprite for.

- font:

  [Font](https://gbkorr.github.io/rcade/reference/render.makefont.md) to
  render the text in.

- wrap:

  Pixels of space alotted to a given line of text before a newline is
  automatically created. `NULL`: no text wrapping.

- kerning:

  Pixels between characters horizontally. Otherwise the font's default
  `$kerning` will be used.

- linespacing:

  Pixels between characters vertically. Otherwise the font's default
  `$linespacing` will be used.

- alignment:

  `'left'`, `'center'`, or `'right'` text alignment.

## Value

Returns a sprite matrix for the text.

## Details

Characters missing from the font will be replaced with blank spaces. If
the font only supports uppercase or lowercase, characters will be
coerced to the supported case.

## Limitations

This function was somewhat messily implemented, but it does its job. A
rewrite would be appropriate someday.

The function currently only supports the wrapping of whole words;
individual words will not be split if they exceed the wrap length.

Wrapping also does not work with strings that manually newline (i.e.
with `\n`).

## Examples

``` r
#basic usage
sprite = render.text('Hello World.', fonts.3x5)
render.matrix(sprite)
#>                                                                                                 
#> []  []                                          []  []                              []          
#> []  []  [][]    [][]    [][]                    []  []                  [][]        []          
#> [][][]  [][]      []      []      []            [][][]    []    [][][]    []      [][]          
#> []  []  []        []      []    []  []          [][][]  []  []  []        []    []  []          
#> []  []    []      []      []      []            []  []    []    []        []      [][]  []      
#>                                                                                                 

#alignment and wrapping
render.matrix(render.text(
  'this text is aligned to the right',
  wrap = 32,
  alignment = 'right'
))
#>                                                                 
#>                                 [][][]  []  []  [][][]    [][]  
#>                                   []    [][][]    []      []    
#>                                   []    []  []  [][][]  [][]    
#>                                                                 
#>                                                                 
#>         [][][]  [][][]  []  []  [][][]          [][][]    [][]  
#>           []    [][]      []      []              []      []    
#>           []    [][][]  []  []    []            [][][]  [][]    
#>                                                                 
#>                                                                 
#>           []    []      [][][]    []    [][][]  [][][]  [][]    
#>         [][][]  []        []    []      []  []  [][]    []  []  
#>         []  []  [][][]  [][][]  [][][]  []  []  [][][]  [][]    
#>                                                                 
#>                                                                 
#>                 [][][]  [][][]          [][][]  []  []  [][][]  
#>                   []    []  []            []    [][][]  [][]    
#>                   []    [][][]            []    []  []  [][][]  
#>                                                                 
#>                                                                 
#>                         [][][]  [][][]    []    []  []  [][][]  
#>                         [][]      []    []      [][][]    []    
#>                         []  []  [][][]  [][][]  []  []    []    
#>                                                                 

#kerning and linespacing
render.matrix(render.text(
  'very spaced text',
  kerning = 3
))
#>                                                                                                                                                                                                 
#> []  []      [][][]      [][][]      []  []                    [][]      [][][]        []        [][][]      [][][]      [][]                    [][][]      [][][]      []  []      [][][]      
#> []  []      [][]        [][]          []                      []        [][][]      [][][]      []          [][]        []  []                    []        [][]          []          []        
#>   []        [][][]      []  []        []                    [][]        []          []  []      [][][]      [][][]      [][]                      []        [][][]      []  []        []        
#>                                                                                                                                                                                                 
#(zoom out with `cmd -` if needed)

#newlines with '\n'
render.matrix(render.text(
  'Newlines:\nAre supported.'
))
#>                                                                                                                 
#> [][][]  [][][]  []  []  []      [][][]  [][][]  [][][]    [][]  []                                              
#> []  []  [][]    [][][]  []        []    []  []  [][]      []                                                    
#> []  []  [][][]  [][][]  [][][]  [][][]  []  []  [][][]  [][]    []                                              
#>                                                                                                                 
#>                                                                                                                 
#>   []    [][][]  [][][]            [][]  []  []  [][][]  [][][]  [][][]  [][][]  [][][]  [][][]  [][]            
#> [][][]  [][]    [][]              []    []  []  [][][]  [][][]  []  []  [][]      []    [][]    []  []          
#> []  []  []  []  [][][]          [][]    [][][]  []      []      [][][]  []  []    []    [][][]  [][]    []      
#>                                                                                                                 
```
