# データ記述言語「Lisla」

**※ この仕様はドラフト（草案）です。予告なく変更される場合があります ※**

Lisla（リスラ, LISt LAnguage）は、データ記述言語です。

Lislaは

* 学ぶのが簡単
* 読むのが簡単
* 書くのが簡単
* パースするのが簡単

です。

YAMLは書くのは簡単ですが、パースをするのは難しいです。JSONはパースをするのは比較的簡単ですが、手で書くのは面倒です。

多くのデータ記述言語は多くの目的に対して複雑すぎます。

Lislaはシンプルで、十分な機能を持っています。

# サンプル

以下は、キャンバスに四角と円を書くという動作を記述したサンプルです。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
; 線の色を赤に
(line_color 0xFF0000)

; 20x20の正方形
(draw_rectangle -10 -10 20 20)

; 半径10の円
(draw_circle 0 0 10)
</pre>
        </td>
        <td>
<pre lang="json">
[
    ["line_color", "0xFF0000"],
    ["draw_rectangle", "-10", "-10", "20", "20"],
    ["draw_circle", "0", "0", "10"]
]
</pre>
        </td>
    </tr>
</table>

Lislaの構文はS式によく似ていますが、LislaはS式ではありません。

Lislaはが持つデータ型は配列(可変長リスト)と、文字列のみです。`nil`やペアのデータ型を持ちません。

Lislaでは値がないことを表現するには長さ0の配列を、ペアを表すには長さ2の配列を使います。

# 構文

## クオートなしの文字列

以下を**含まない**記述は、文字列データとみなされます。
* 特殊文字 : `"'()$`
* 改行文字 : LF(#xA), CR(#xD)
* 空白文字 : `` ``(#x20), `\t`(#x9)
* コメント文字 : `;`
* ブラックリスト空白文字(全角スペースなど、詳しくは後述)

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">abcd</pre>
        </td>
        <td>
<pre lang="json">["abcd"]</pre>
        </td>
    </tr>
</table>

Lislaは最上位の階層は配列です。つまり、単純な`abcd`という記述は、JSONの`["abcd"]`に相当します。

## 区切り文字(空白文字と改行文字)

Lislaにおける区切り文字は、空白文字(`` ``(#x20), `\t`(#x9))と改行文字(LF, CR)です。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
a
b c
def</pre>
        </td>
        <td>
<pre lang="json">
["a", "b", "c", "def"]</pre>
        </td>
    </tr>
</table>

連続した区切り文字と、文頭または文末の区切り文字は無視されます。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">

a

b  c   
def
 
</pre>
        </td>
        <td>
<pre lang="json">
["a", "b", "c", "def"]
</pre>
        </td>
    </tr>
</table>

## クオートありの文字列

特殊な文字を文字列データに含めたい場合、ダブルクオート(`"`)とシングルクオート(`'`)で囲みます。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
"(abc 'def')" ' "abc" '
</pre>
        </td>
        <td>
<pre lang="json">
["(abc, 'def')", " \"abc\" "]
</pre>
        </td>
    </tr>
</table>

クオートの数は、3つまたはそれ以上でも構いません。この場合、同じ種類かつ同じ数のクオートを使って閉じます。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
"""a"b"c""" '''' 'abc' ''''
</pre>
        </td>
        <td>
<pre lang="json">
["a\"b\"c", " 'abc' "]
</pre>
        </td>
    </tr>
</table>

クオート2つはそれ単体で空白文字列の意味になります。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
'' ""
</pre>
        </td>
        <td>
<pre lang="json">
["", ""]
</pre>
        </td>
    </tr>
</table>


## 入れ子

配列を入れ子にしたい場合、丸かっこ`()`で囲みます。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
a ((bc def) (g))
</pre>
        </td>
        <td>
<pre lang="json">
["a", [["bc", "def"], ["g"]]]
</pre>
        </td>
    </tr>
</table>

丸カッコの前後の区切り文字は省略可能です。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
("a"(bc def)(g))(("hi")jk)
</pre>
        </td>
        <td>
<pre lang="json">
[["a", [["bc", "def"], ["g"]]], [["hi"], "jk"]]
</pre>
        </td>
    </tr>
</table>

## 複数行文字列

Lislaでは、複数行のクオートあり文字列が使用できます。

複数行の文字列構文ではきれいなフォーマットで記述ができるように、以下のルールにしたがって、空白文字や改行は無視されます。

* 最初の行が空白文字のみからなる場合、その空白文字と最初の改行は無視されます。（**先頭空白行の除去**）
* 最終行が空白文字のみからなる場合、その空白文字と最後の改行は無視されます。（**最終空白行の除去**）
* 最終行が空白文字のみからなる場合、それと同じ空白文字列が最初の行以外のすべての行の先頭から除去されます（**インデントの除去**）
    * この場合、各行は「最終行の空白文字と同じ並びで始まる」か「空行」かのどちらでなくてはなりません。

このとき、改行は`\r\n`、`\n`、`\r`のいずれかで、1つの改行というあつかいです。

<table>
    <tr><th>Lisla</th><th>JSON</th></tr>
    <tr>
        <td>
<pre lang="lisla">
"
Multi
line
"
    '''''
    Lisla
     is
      awesome.
    '''''
</pre>
        </td>
        <td>
<pre lang="json">
["Multi\nline", "Lisla\n is\n  awesome."]
</pre>
        </td>
    </tr>
</table>

## ブラックリスト空白文字列

以下は、空白文字のブラックリストです。これらは紛らわしい挙動を引き起こすため、クオート無し文字列に含めることはできません。

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

## コメント

Lislaでは行コメントが使えます。

```lisla
; this is comment
string ; this is also comment
```

Lislaはブロックコメントはサポートしていません。

### ドキュメントコメント

`;;`で始まるコメントはドキュメントコメントです。

```lisla
;; """
;; # ドキュメントコメントのサンプル
;; 
;; これは最初の要素に対するドキュメントコメントです。
;; 各ドキュメントコメントは、直後に来る要素に対するドキュメントコメントとしてあつかわれます。
;; """
aaa
```

ドキュメントコメントの内容もLislaで記述します。

### 親配列に対するドキュメントコメントです

`;;;`で始まるコメントは、それをふくむ親配列に対するドキュメントコメントです。

```lisla
;;; """
;;; これは配列自体のドキュメントコメントとしてあつかわれます。
;;; つまり、このコメントはドキュメント全体に対するドキュメントコメントです。
;;; """
;;; (author shohei909)
;;; (license Unlicense)
;;; (document_markup markdown)
aaa
```


### 保護されたコメント

`;!`と`;;!`と`;;;!`は、ツールによる空白除去やコメント除去を行った場合に除去されないコメントを意味します。

```
;! 「!」で始まるコメントはLislaがminifyされる際に除去されません
;;! '保護されたドキュメントコメントも利用可能です'
;;;! 'これも保護されたコメントです'
```

## プレースホルダー

`$`の直後から、クオートなし文字列またはクオートあり文字列を始めると、それはプレースホルダーを表します。

```lisla
$ここにユーザーIDを記入する
$"TODO: 説明文を記入する"
```

プレースホルダーはそこに何か入れられるべき値があり、まだ入れられていないことを表します。つまり、プレースホルダーをふくむLislaは未完成のLislaです。

プレースホルダーをふくむLislaを完成したLislaとして読み込もうとするとエラーになります。

プレースホルダーは、主に以下の目的のために使います。
* 未完成のLislaが、完成済みのLislaと取り違えられるの防ぐため
* 構文解析、入力補完などのツールが、未完成のLislaの構造を正しく読み取るための補助のため
* Lislaをテンプレートエンジンとして使うため

## エンコード

LislaはUTF-8のみをサポートしています。

ドキュメントの先頭にBOM（0xEF 0xBB 0xBF）があった場合、無視します。

## 拡張子

`.lisla`

## 実装

### Rust

標準実装

## 新しいLislaパーサを実装する上で

多くのテストケースが用意されているのでそちらに目を通してください。

## バージョン

ここで説明されている`Lisla`のバージョンは`0.0.1`です。
