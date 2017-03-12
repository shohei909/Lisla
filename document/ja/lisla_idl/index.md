# Lislaインターフェース記述言語(Lisla IDL)

Lisla IDLは、Lislaで記述したデータがどのような構造を持つかを記述するためのスキーマ言語です。

## 簡単な例

Lisla IDLで文書の構造を定義する簡単な例を見ていきます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(newtype Row (Array String))
</pre>
        </td>
        <td>
<pre lang="lisla">
(a b c d)
</pre>
        </td>
    </tr>
</table>

`(newtype Row (Array String))` という文に出てきた要素を、一つずつ見ていきます。

* `newtype`は、新しい型を宣言するためのキーワードです。
* `Row`は、新しい型の名前です。
* `(Array String)`は、`Row`の構造のもとになる型です。
   * `Array`は配列の型です。デフォルトで存在している基本型で、引数を1つ持ちます。
       * 引数を持つ型は、配列の第一要素に型名を書き、第二要素以降に引数の情報を書きます
   * `String`は文字列の型です。デフォルトで存在している基本型で、引数は持ちません。
       * 引数を持たない型は、単なる文字列として型名を書きます。

つまり、`(newtype Row (Array String))`は「`Row`という名前で`(Array String)`の構造を持つ新しい型を作る」という意味です。

このように定義した、`Row`型はまた別の型を構成するために使うことができます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(newtype Table (Array Row))
</pre>
        </td>
        <td>
<pre lang="lisla">
(
    (a b c d)
    (e f g h)
    (i j k l)
)
</pre>
        </td>
    </tr>
</table>

## 4種類のユーザー定義型

Lisla IDLでは、4種類の型を定義することで文書の構造を書き表します。

### newtype (新しい型)

`newtype`は、ほかの型をもとにして同じ構造を持つ新しい型を作ります。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(newtype Url String)
</pre>
        </td>
        <td>
<pre lang="lisla">
http://example.com
</pre>
        </td>
    </tr>
</table>

例えば、上記のように、`String`を元にした新しい型`Url`型を作ることで、IDLを読んだ人やプログラムがそれが具体的にどういう意味の文字列なのかを認識しやすくなります。


### tuple (タプル構造体の型)

`tuple`は、タプル構造体の型を作ります。

タプル構造体は、各要素ごとに要素名と型を定義した配列です。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(tuple WebPage
    (title String)
    (url Url)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
("Example Domain" http://example.com)
</pre>
        </td>
    </tr>
</table>

この例の場合、1つ目の要素の名前が`title`で型が`String`、2つ目の要素の名前が`url`で型が`Url`です。タプル構造体`WebPage`はこの2つの要素で構成される配列です。

また、タプル構造体のもつ、型と名前が指定された各要素のことを「引数（argument）」と呼びます。

### struct (構造体の型)

`struct`は、構造体の型を作ります。

構造体はキーと値のペアの配列で、各キーに対する型が定義されています。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct WebPageStruct
    (title String)
    (url Url)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(
    (title "Example Domain")
    (url http://example.com)
)
</pre>
        </td>
    </tr>
</table>

各ペアは、順番が変わってもかまいません。

```
(
    (url http://example.com)
    (title "Example Domain")
)
```

### enum (列挙型)

`enum`は列挙体の型です。

列挙体は、型に定義された値のうちいずれかの値をとります。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(enum Boolean
    true
    false
)
</pre>
        </td>
        <td>
<pre lang="lisla">
true
</pre>
        </td>
    </tr>
</table>

この例では、`true`または`false`のどちらかを値として持つ`Boolean`型を定義しています。

この`true`と`false`のような、列挙体の各候補を「列挙子」と呼びます。

列挙子は文字列のみに限りません。以下の`rgb`のように第1要素にラベルを持つ配列を指定することもできます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(enum Color
    red
    blue
    green
    (rgb (r UInt8) (g UInt8) (b UInt8))
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(rgb 255 220 200)
</pre>
        </td>
    </tr>
</table>

`enum Color`の`rgb`の2つ目以降の要素は引数です。タプル構造体の引数と同じように、名前と型が指定されています。

## 高度な機能

### tuple、enumの引数の高度な機能

#### ラベル

`tuple`と`enum`の引数の名前と型のペアを記述する代わりに、文字列を置くことで「ラベル」を配置することができます。

ラベルは、その位置の要素に対してラベルと一致する文字列であることを要求します。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(tuple Addition
    (number0 Float64) + (number1 Float64)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(1.5 + 3.5)
</pre>
        </td>
    </tr>
</table>

この例では、`tuple Addition`の2つ目の要素が`+`という文字列であることを要求しています。


#### オプショナル引数 `?`




#### 可変長引数  `..`

#### インライン引数 `<`

#### デフォルト値

#### 各機能の複合的な利用

tupleとenumの引数の高度な機能に以下の組み合わせについては重複した利用が可能です

* インライン引数と可変長引数 `..<`
* インライン引数とオプショナル引数 `?<`
* インライン引数とデフォルト値

他の機能については重複した利用はできません。

### structの要素の高度な機能

#### ラベル

#### オプショナル要素 `?`

#### 可変長要素 `..`

#### インライン要素 `<`

#### structのマージ `<<`

#### デフォルト値

#### 各機能の複合的な利用

structの要素の高度な機能に以下の組み合わせについては重複した利用が可能です

* オプショナルラベル
* 可変長ラベル
* インライン要素と可変長要素 `..<`
* インライン要素とオプショナル要素 `?<`
* インライン要素とデフォルト値

他の機能については重複した利用はできません。

### enumの列挙子の高度な機能

#### タプル列挙子

#### インライン列挙子

#### 各機能の複合的な利用

enumの列挙子の高度な機能


## 相互変換性

Lisla IDLによってLisla文書の構造の明確化する目的の1つに、Lisla文書とプログラムの内部データとの相互変換の自動化があります。

この相互変換というのは、以下の2つの方向の変換のことです。

* Lislaのテキストファイルから、プログラムの内部データへの変換
* プログラムの内部データから、Lislaのテキストファイルへの変換

Lisla IDLはこの2方向の変換を行った場合に、データが欠損したり、壊れたりしないことを保証するために、各機能にはいくつかの制限が加えられます。

例えば以下のようなものです。

* 条件の重複する列挙子の禁止
* 条件の重複するstruct要素の禁止
* オプション引数や可変長引数の直後での条件の重複する引数の禁止。

具体的にどのような制限を受けるかは、[こちら](constraint.md)を参照してください。

## 型の引数

## その他の制限


## Lisla IDL のモジュールシステム

### ライブラリ

### モジュール

### パッケージ

## 標準ライブラリ


## コーディング規約

### 命名

原則として以下の記法の使用を推奨しています。

* 型名: PascalCase
* 引数名: snake_case
* 列挙子名: snake_case
* structの要素名: snake_case

ただし、列挙子名とstructの要素名は、実際の文書構造に影響を与えます。このため実際の文書の都合上、この規約にしたがえない場合は実際の文書の都合を優先してかまいません。

また、IDLを元にプログラミング言語などのソースコードを出力する場合には、出力の過程でそのプログラミング言語にあった記法に変換してかまいません。
