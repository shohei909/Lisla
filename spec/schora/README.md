# Schora 

NOTE : This document is work in progress

Schora means "SCHema language for sORA". It types sora data staticaly.

# Example

Here is a schema for a simple visual novel script.

```
[main
    [array
        [rest
            [or
                [const string]
                [const command]
            ]
        ]
    ]
]

[def [command]
    [or 
        [const, left]
        [const, right]
        [array
            [required
                [const, custom]
                [ref, float, 64]
            ]
        ]
    ]
]

[def [character_id]
    [or
        [const, alice]
        [const, rabbit]
    ]
]
```

Then actual script is below:

```
// Chapter I:  DOWN THE RABBIT HOLE
[play_bgm, bank.mp3]
[display_background, bank.png]
[display_character, alice, [custom, 0.5]]
"""
Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, 
"""

[play_voice, voice0.mp3]
"""
“and what is the use of a book,” thought Alice, 
"""

[play_voice, voice1.mp3]
"""
“without pictures or conversations?”
"""
"""
So she was considering, in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.
"""
```

# Supported Data Type

## Scalar

### Int

### Uint

### Hex

### Bool

### Constant

#### Schema
```
[ [xml_declaration]
    [const, ?xml]
]
```

#### Use
```
?xml
```

## Collections

Schora maps Sora array to various collection.  

### Enum

#### Schema
```
// Define color as enum.
[ [color]
    [ enum
        /// Alias for 0xFF0000 
        [red]
        /// Alias for 0x00FF00
        [green]
        /// Alias for 0x0000FF
        [blue]

        /// RGB color
        [ rgb 
            /// 0xRRGGBB
            [hex]
        ]

        /// HSV Color
        [ hsv
            /// Hue
            [float]
            /// Saturation
            [float]
            /// Value 
            [float]
        ]
    ]
]
```

#### Use
```
[green]
```

```
[rgb, 0x000000]
```

```
[hsv, 0.00, 0.22, 0.64]
```

### Rest

## Other

# Note 
## To implement object mapper
This schema language is for supporting human (e.g. linting, auto completion). 

In many cases, schema is incomplete. For example, Schora for Schora doesn't prohibit the dupplication of defined type name.

So that, object mapper should not use Schora to map Sora data to object, especially in static typed language.
Object mapper should follow only language's data types. Otherwise, operations like cast and validation will be dupplicated and it incleases difficulty.

If you want to use both of object mapper and schema, I recommend to use tools for generating Schora from language's data type like [libsora](/imple/rust/libsora). 

## Lisence 
This document is lisenced under [CC0](https://creativecommons.org/publicdomain/zero/1.0/deed.en)
