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

If a description includes no special characters (`"'[]`), newline characters (LF(#xA), CR(#xD)), white spaces (`` ``(#x20) or `\t`(#x9)), or comment syntax (`//`), it is considered string.

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

If you want to include special characters or white spaces in string, you can enclose string with double quotes `"` or  single quotes `'`.

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

### Multi-line string

If you want to include newline in string, multi-line string syntax can be use.
Multi-line string syntax starts with 3 or more double or single quotes, and end with same quotes.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"""
Multi
line
"""
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
    <td><code>\\\\</code></td>
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

## Array

### Comma separator 

As you already seen, strings can be separate with comma (`,`).

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
a, bc, def
            </code></pre>
        </td>
        <td>
            <pre><code>
["a", "bc", "def"]
            </code></pre>
        </td>
    </tr>
</table>

### Newline separator

Newline (LF, CR, CR+LF) can be also use as separator.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
a
bc
def
            </code></pre>
        </td>
        <td>
            <pre><code>
["a", "bc", "def"]
            </code></pre>
        </td>
    </tr>
</table>

### Nest

Nested array start with opening bracket `[` and end with closing bracket `]`.

<table>
    <tr><th>Sora</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
[a, [[bc, def], [g]]]
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
[a [bc, def] [g]] [[h\ni] jk]
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


,,[,c,
,[,],,]

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

Current specfication version is `0.1` (draft).  
<!-- Current test cases version is `0.1.0`. -->

## Lisence 
This document and test cases is lisenced under [CC0](https://creativecommons.org/publicdomain/zero/1.0/deed.en)
