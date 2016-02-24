# Sora is a human-readable data serialization language 

Sora means "String OR Array". As it suggests, Sora only supports string and array data type.

So Sora is
* easy to learn,
* easy to read,
* easy to write,
* and easy to parse.

YAML is easy to write but difficult to parse. JSON is relatively easy to parse, but difficult to write. 

Most of data serialization languages are too complex for many purposes.

Sora is simple, but enough.

# Examples

## String

### Unquoted string

If a description includes no special characters (`"'[],`), newline characters (LF(#xA), CR(#xD)), whitespaces (`` ``(#x20) or `\t`(#x9)), blacklisted whitespaces, or comment syntax (`//`), it is considered string.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
abcd
            </code></pre>
        </td>
        <td>
            <pre><code>
["abcd"]
            </code></pre>
        </td>
    </tr>
</table>

The root of Sora is array, so that single `abcd` corresponds to `["abcd"]` of JSON.

### Quoted string

If you want to include special characters, whitespaces or blacklisted whitespaces in string, you can enclose the string with double quotes `"` or  single quotes `'`.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"[abc, 'def']", ' "abc" '
            </code></pre>
        </td>
        <td>
            <pre><code>
["[abc, 'def']", " \"abc\" "]
            </code></pre>
        </td>
    </tr>
</table>

The quotes number can be 3 or more. 

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"""a"b"c""", '''' 'abc' ''''
            </code></pre>
        </td>
        <td>
            <pre><code>
["a\"b\"c", " 'abc' "]
            </code></pre>
        </td>
    </tr>
</table>

2 quotes can not be use, because `""` and `''` mean an empty string.

### Multi-line string

Sora supports multi-line quoted string syntax.

In multi-line string syntax, some whitespaces and newlines are ignored. 

* If the line of openinng quote has only white spaces, the white spaces and first newline are ignored.  
* If the line of closing quote has only white spaces, the white spaces and last newline are ignored.
* If the line of closing quote starts with white spaces, same number of white spaces at the start of each lines excepting openinng quote line are ignored. In this case each of the white spaces must have same sequence.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"
Multi
line
"
    '''''
    Sora
     is
      awesome.
    '''''
            </code></pre>
        </td>
        <td>
            <pre><code>
["Multi\nline", "Sora\n is\n  awesome."]
            </code></pre>
        </td>
    </tr>
</table>

## Escape sequences

Sora also supports escape sequences:

<table>
    <tr>
    <td><code>\n</code></td>
    <td>Newline</td>
    </tr>
    <tr>
    <td><code>\r</code></td>
    <td>Carriage return</td>
    </tr>
    <tr>
    <td><code>\t</code></td>
    <td>Tab</td>
    </tr>
    <tr>
    <td><code>\\</code></td>
    <td>Backslash</td>
    </tr>
    <tr>
    <td><code>\0</code></td>
    <td>Null</td>
    </tr>
    <tr>
    <td><code>\'</code></td>
    <td>Single quote</td>
    </tr>
    <tr>
    <td><code>\"</code></td>
    <td>Double quote</td>
    </tr>
    <tr>
    <td><code>\u{7FFF}</code></td>
    <td>24-bit Unicode character code (<code>\u{0}-\u{10FFFF}</code>, 1-6 degits). Case insensitive.</td>
    </tr>
</table>

Escape sequences can be use in each of string literal.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"Multi\r\nLine", "\"", \u{305D}\u{3089}
            </code></pre>
        </td>
        <td>
            <pre><code>
["Multi\r\nline", "\"", "そら"]
            </code></pre>
        </td>
    </tr>
</table>

### Blacklisted whitespaces

Below is the blacklist of whitespace characters. They could cause confusing behavior, So that, Sora prohibits the use of them in unquoted string.

* `U+000B` (VT, Vertical Tab)
* `U+000C` (FF, From feed)
* `U+0085` (NEL, Next line) 
* `U+00A0` (No break space)
* `U+1680` (Ogham space mark)
* `U+2000` (En quad)
* `U+2001` (Em quad)
* `U+2002` (En space)
* `U+2003` (Em space)
* `U+2004` (Three-per-em space)
* `U+2005` (Four-per-em space)
* `U+2006` (Six-per-em-space)
* `U+2007` (Figure space)
* `U+2008` (Punctuation space)
* `U+2009` (Thin space)
* `U+200A` (Hair space)
* `U+2028` (Line sparator)
* `U+2029` (Paragraph sparator)
* `U+202F` (Narrow no-break space)
* `U+205F` (Medium mathematical space)
* `U+3000` (Ideographic space)

## Array

### Comma separator 

As you already seen, strings can be separate with comma (`,`).

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
a,bc,def
            </code></pre>
        </td>
        <td>
            <pre><code>
["a", "bc", "def"]
            </code></pre>
        </td>
    </tr>
</table>

### Whitespace separator, Newline separator

Whitespaces(`` ``(#x20), `\t`(#x9)) and newlines(LF, CR, CR+LF) can be also use as separator.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
a
b c
def
            </code></pre>
        </td>
        <td>
            <pre><code>
["a", "b", "c", "def"]
            </code></pre>
        </td>
    </tr>
</table>

### Nest

Nested array starts with opening bracket `[` and ends with closing bracket `]`.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
[a [[bc def] [g]]]
[ 
    [ 
        """
        h
        i
        """
    ]
    jk
]
            </code></pre>
        </td>
        <td>
            <pre><code>
[["a", [["bc", "def"], ["g"]]], [["h\ni"], jk]]
            </code></pre>
        </td>
    </tr>
</table>

You can omit separators after or before brackets.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
["a"[bc def][g]][[h\ni]jk]
            </code></pre>
        </td>
        <td>
            <pre><code>
[["a", [["bc", "def"], ["g"]]], [["h\ni"], "jk"]]
            </code></pre>
        </td>
    </tr>
</table>

## Skipping 

Sora skips unquated empty string.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
,a,,b,


  ,,[  ,c,
,[,],  ,]

,d


            </code></pre>
        </td>
        <td>
            <pre><code>
["a", "b", ["c", []], "d"]
            </code></pre>
        </td>
    </tr>
</table>

If you want to express empty string, use `""` or `''`. 

## Comment

Sora supports single line comment.

```
// this is comment
string // this is also comment
```

Multi-line comment is not supported.

### Document comment

```
/// This is comment for various tools (e.g. editor, document generation).
/// @[ // add tags with sora
///     [auther, shohei909]
///     [version, 0.1]
///     [license, "public domain"]
/// ]
```

### Keeping comment

```
//! Comments start with ! are keeped when Sora is minified.
///! Keeping document comments are also avarable.
```

## Encoding

Supported encoding is UTF-8 (with or without BOM).

## Filename extension

`.sora`

## Implementation

### Rust

- libsora : Official implementation. 
- sorac   : CLI tools based on libsora.

## To implement new Sora parser.

Many test cases are prepared. You should check all of them.

## Version

<!-- Current specfication version is `0.1` (draft). -->  
<!-- Current test cases version is `0.1.0`. -->

## Lisence 
This document and test cases is lisenced under [CC0](https://creativecommons.org/publicdomain/zero/1.0/deed.en)
