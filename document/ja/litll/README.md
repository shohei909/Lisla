# データ記述言語 Litll

Litllは、文字列と配列のみをサポートするデータ記述言語です。

このため、
* 学ぶのが簡単で、
* 読むのが簡単で、
* 記述するのも簡単で、
* パースするのも簡単です。

YAMLは記述はしやすいですがパースは難しいです。JSONは比較的パースは楽ですが、記述は大変です。 

ほとんどのデータ記述言語は、ほとんどの目的に対して複雑すぎます。

Litllはシンプルです。ですが、十分な機能があります。



# 構文

## 文字列

### クオートなしの文字列

以下の特殊文字、構文を含まない記述は、文字列と解釈されます。

* クオート(`"'`)
* 大かっこ(`[]`)
* 改行文字(LF(#xA), CR(#xD))
* 空白文字(`` ``(#x20) or `\t`(#x9))
* 禁止空白文字(後述)
* コメント構文(`//`)


<table>
    <tr><th>Litll</th><th>Json</th></tr>
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

Litllはルートが配列です。ただ単に`abcd`と記述した場合、JSONの`["abcd"]`という記述と同じになります。

### クオートされた文字列

文字列に特殊文字を含めたい場合、ダブルクオート`"`またはシングルクオート`'`で、文字列を囲みます。

<table>
    <tr><th>Litll</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"[abc 'def']" ' "abc" '
            </code></pre>
        </td>
        <td>
            <pre><code>
["[abc, 'def']", " \"abc\" "]
            </code></pre>
        </td>
    </tr>
</table>

クオートの数は、3つ以上でも構いません。

<table>
    <tr><th>Litll</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"""a"b"c""" '''' 'abc' ''''
            </code></pre>
        </td>
        <td>
            <pre><code>
["a\"b\"c", " 'abc' "]
            </code></pre>
        </td>
    </tr>
</table>

クオート2つで囲むことはできません。`""`や`''`は空白文字列の意味になります。


### 複数行文字列

Litllでは、クオートされた文字列で複数行文字列を使うことができます。

複数行文字列では、フォーマットのためのインデントや改行を使いやすくするため、特定の改行や空白文字が無視されます。

* 文字列の最終行が空白文字から始まる場合、最初の行と空行を除くすべての行で先頭の同じ空白文字が削除されます。
    * 最終行と削除対象の行の空白文字が一致しない場合、エラーです。
* 最初の行が空白文字のみからなる場合、その空白文字と、最初の改行は無視されます。
* 最後の行が空白文字のみからなる場合、その空白文字と、最後の改行は無視されます。

<table>
    <tr><th>Litll</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"
Multi
line
"
    '''''    
    Litll
    
     is

      awesome.
    '''''
            </code></pre>
        </td>
        <td>
            <pre><code>
["Multi\nline", "Litll\n\n is\n\n  awesome."]
            </code></pre>
        </td>
    </tr>
</table>

## Escape sequences

Litll also supports escape sequences:

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

Escape sequences can be use in unquoted strings or quoted strings of double-quotes.

<table>
    <tr><th>Litll</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
"Multi\r\nline" "\"" \u{305D}\u{3089}
            </code></pre>
        </td>
        <td>
            <pre><code>
["Multi\r\nline", "\"", "そら"]
            </code></pre>
        </td>
    </tr>
</table>

In quoted strings of single-quotes, escape sequences are disabled. 

<table>
    <tr><th>Litll</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
'Single\r\nline' '\' '''\u{305D}\u{3089}'''
            </code></pre>
        </td>
        <td>
            <pre><code>
["Single\\r\\nline", "\\", "\\u{305D}\\u{3089}"]
            </code></pre>
        </td>
    </tr>
</table>

### Blacklisted whitespaces

Below is the blacklist of whitespace characters. They could cause confusing behaviors. So that, Litll prohibits the use of them in unquoted strings.

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

### Whitespace separator, Newline separator

Whitespaces(`` ``(#x20), `\t`(#x9)) and newlines(LF, CR) are used as separator.

<table>
    <tr><th>Litll</th><th>Json</th></tr>
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
    <tr><th>Litll</th><th>Json</th></tr>
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
    <tr><th>Litll</th><th>Json</th></tr>
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

Litll skips unquated empty string.

<table>
    <tr><th>Litll</th><th>Json</th></tr>
    <tr>
        <td>
            <pre><code>
a  b


  [  c
[]   ]

d


            </code></pre>
        </td>
        <td>
            <pre><code>
["a" "b" ["c" []] "d"]
            </code></pre>
        </td>
    </tr>
</table>

If you want to express empty string, use `""` or `''`. 

## Comment

Litll supports single line comment.

```
// this is comment
string // this is also comment
```

Multi-line comment is not supported.

### Document comment

```
/// [document
///     '''
///     # Sample for document comment.
///
///     This is comment for various tools (e.g. editor, document generation).
///     '''
///     [auther shohei909]
///     [version 0.1]
///     [license "public domain"]
///     [document_format markdown]
/// ]

/// 'first element'
aaa
```

Document comment is also described with Litll. 

### Keeping comment

```
//! Comments start with ! are keeped when Litll is minified.
///! 'Keeping document comments are also avarable.'
```

## Encoding

Supported encoding is UTF-8 (with or without BOM).

## Filename extension

`.litll`

## Implementation

### Rust

- liblitll : Official implementation. 
- litllc   : CLI tools based on liblitll.

## To implement new Litll parser.

Many test cases are prepared. You should check all of them.

## Version

<!-- Current specfication version is `0.2` (draft). -->  
<!-- Current test cases version is `0.1.0`. -->

## Lisence 
This document and test cases is lisenced under [CC0](https://creativecommons.org/publicdomain/zero/1.0/deed.en)