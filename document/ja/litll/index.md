# データ記述言語「Litll」

Litll（リトル）は、文字列型と配列型のみをサポートするデータ記述言語です。

Litllは
* 学ぶのが簡単で
* 読むのが簡単で
* 書くのが簡単で
* パースするのが簡単です。

YAMLは書くのは簡単ですが、パースをするのは難しいです。JSONはパースをするのは比較的簡単ですが、手で書くのは面倒です。

多くのデータ記述言語は多くの目的に対して複雑すぎます。

Litllはシンプルです。そして、十分な機能を持っています。

# 構文

## クオートなしの文字列

以下を**含まない**記述は、文字列データとみなされます。
* 特殊文字(`"'[],`)
* 改行文字(LF(#xA), CR(#xD))
* 空白文字(`` ``(#x20), `\t`(#x9))
* ブラックリスト空白文字(全角スペースなど、詳しくは後述)
* コメント構文(`//`)

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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

Litllは最上位の階層が配列なので、単純な`abcd`という記述は、JSONの`["abcd"]`に相当します。

## 区切り文字(空白文字と改行文字)

空白文字(`` ``(#x20), `\t`(#x9))と改行文字(LF, CR)は区切り文字として使うことができます。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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

連続した区切り文字、文頭/文末の区切り文字は無視されます。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
    <tr>
        <td>
            <pre><code>

a

b  c   
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

## クオートありの文字列

特殊文字、空白文字、ブラックリスト空白文字を文字列データに含めたい場合、ダブルクオート(`"`)とシングルクオート(`'`)で囲みます。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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

クオートの数は、3つまたはそれ以上でも構いません。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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

クオート2つは空白文字列の意味になります。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
    <tr>
        <td>
            <pre><code>
'' ""
            </code></pre>
        </td>
        <td>
            <pre><code>
["", ""]
            </code></pre>
        </td>
    </tr>
</table>


## 入れ子

配列を入れ子にしたい場合、大かっこ`[]`で囲みます。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
    <tr>
        <td>
            <pre><code>
a [[bc def] [g]]
            </code></pre>
        </td>
        <td>
            <pre><code>
["a", [["bc", "def"], ["g"]]]
            </code></pre>
        </td>
    </tr>
</table>

大カッコの前後の区切り文字は省略可能です。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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


## 複数行文字列

Litllでは、複数行のクオートあり文字列が使用できます。

複数行の文字列構文では、いくつかの空白文字や改行は無視されます。

* 最初の行が空白文字のみからなる場合、その空白文字と最初の改行は無視されます。（**先頭空白行の除去**）
* 最終行が空白文字のみからなる場合、その空白文字と最後の改行は無視されます。（**最終空白行の除去**）
* 最終行が空白文字から始まる場合、それと同じ空白文字列が最初の行以外のすべての行の先頭から除去されます（**インデントの除去**）
    * この場合各行は、「最終行の空白文字と同じ並びで始まる」か「空行」かのどちらでなくてはなりません。

改行は`\r\n`、`\n`、`\r`のいずれかで、1つの改行というあつかいです。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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


## エスケープシークエンス

Litllでは、クオート無しの文字列と、ダブルクオートのクオート有りの文字列でエスケープが利用可能です。

<table>
    <tr>
    <td><code>\n</code></td>
    <td>LF</td>
    </tr>
    <tr>
    <td><code>\r</code></td>
    <td>CR</td>
    </tr>
    <tr>
    <td><code>\t</code></td>
    <td>タブ文字</td>
    </tr>
    <tr>
    <td><code>\\</code></td>
    <td>バックスラッシュ</td>
    </tr>
    <tr>
    <td><code>\0</code></td>
    <td>ヌル文字</td>
    </tr>
    <tr>
    <td><code>\'</code></td>
    <td>シングルクオート</td>
    </tr>
    <tr>
    <td><code>\"</code></td>
    <td>ダブルクオート</td>
    </tr>
    <tr>
    <td><code>\u{7FFF}</code></td>
    <td>24-bit ユニコード文字コード (<code>\u{0}-\u{10FFFF}</code>, 16進数で1-6桁、大文字小文字区別なし)</td>
    </tr>
</table>

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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

シングルクオートのクオート有りの文字列では、これらのエスケープはされません。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
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

## ブラックリスト空白文字列

以下は、空白文字のブラックリストです。これらは紛らわしい挙動を引き起こすため、これらの文字をクオート無し文字列に含めることはできません。

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

## 配列補間

文字列内で`\[`から始めて`]`で閉じることで、その配列の内容を文字列の間に挿入することができます。つまり以下のようなことです。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
    <tr>
        <td>
            <pre><code>
    "
    配列補間はインデントを壊さないので
     例えばLitllを、\[bold "マークアップ言語のように"]
      使う場合に役立ちます
    "
            </code></pre>
        </td>
        <td>
            <pre><code>
["配列補間はインデントを壊さないので\n 例えばLitllを、", ["bold", "マークアップ言語のように"], "\n  使う場合に役立ちます"]
            </code></pre>
        </td>
    </tr>
</table>

配列補間の`\[]`の内側では、'\'でエスケープされた区切り文字によって、複数の配列を文字列の間に挿入できます。

<table>
    <tr><th>Litll</th><th>JSON</th></tr>
    <tr>
        <td>
            <pre><code>
"a\[b \ c [d]]d"
            </code></pre>
        </td>
        <td>
            <pre><code>
["a", ["b"], ["c", ["d"]], "e"]
            </code></pre>
        </td>
    </tr>
</table>

## コメント

Litllでは行コメントが使えます。

```
// this is comment
string // this is also comment
```

複数行のコメントはサポートしていません。

### ドキュメントコメント

`///`で始まるコメントはドキュメントコメントです。

```
/// """
/// # ドキュメントコメントのサンプル
/// 
/// これは様々なツール(エディタやドキュメント生成など)向けのコメントです。
/// """
/// [author shohei909]
/// [license "Public Domain"]
/// [document_markup markdown]

/// "最初の要素に対するドキュメントコメント"
aaa
```

ドキュメントコメントの内容もLitllで記述します。

### 保護されたコメント

`//!`と`///!`は、ツールによる空白除去やコメント除去を行った場合に除去されないコメントを意味します。

```
//! 「!」で始まるコメントはLitllがminifyされる際に除去されません
///! '保護されたドキュメントコメントも利用可能です'
```

## エンコード

LitllはUTF-8のみをサポートしています。 (BOMありなし両方)

## 拡張子

`.litll`

## 実装

### Haxe

- hxlitll : 公式実装

### Rust

- liblitll : 公式実装

## 新しいLitllパーサを実装する上で

多くのテストケースが用意されているのでそちらに目を通してください。

## バージョン

ここで説明されている`Litll`のバージョンは`1.0.0`です。

## ライセンス
このドキュメントとテストケースのライセンスは[Creative Commons 0](https://creativecommons.org/publicdomain/zero/1.0/deed.en)です。

各実装のライセンスは各実装のディレクトリを確認してください。