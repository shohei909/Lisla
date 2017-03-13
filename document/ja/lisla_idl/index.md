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

引数の名前と型のペアを記述する代わりに、文字列を置くことで「ラベル」を配置することができます。

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

引数名に`?`の接尾辞(サフィックス)をつけることで、引数を省略可能にすることができます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(tuple OptionalArgumentSample
    (title String)
    (description? String)  
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(省略可能引数サンプル)
</pre>
        </td>
    </tr>
</table>

この例では、`description`に対する値を省略しています。

#### 可変長引数  `..`

引数名に`..`のサフィックスをつけることで、引数を0個以上の可変長にすることができます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(tuple VariableArgumentSample
    (title String)
    (tags.. String)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(可変長引数サンプル タグ1 タグ2)
</pre>
        </td>
    </tr>
</table>

この例では、`tags`に対して「タグ1」と「タグ2」の2つの値を指定しています。

#### スプレッド引数 `<`

引数名に`<`のサフィックスをつけることで、その引数の型に応じた引数列をその位置に展開した形で記述させることができます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(tuple SpreadArgumentSample
    (user_name String)
    (page< WebPage)
)

(tuple WebPage
    (title String)
    (url Url)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(shohei "Example Domain" http://example.com)
</pre>
        </td>
    </tr>
</table>

この例では、ユーザー名とそのウェブページに関する情報について、フラットな配列で記述しています。

#### デフォルト値

引数の名前と型の、次の要素として値を記述することで、その引数は省略可能となり省略時のデフォルト値としてその値が使用されます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(tuple RgbaColor
    (red UInt8)
    (green UInt8)
    (blue UInt8)
    (alpha UInt8 255)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(255 220 200)
</pre>
        </td>
    </tr>
</table>

この例では`alpha`の値が省略されており、代わりにデフォルト値の`255`が使われます。

#### 各機能の複合的な利用

tupleとenumの引数の高度な機能に以下の組み合わせについては重複した利用が可能です

* スプレッド引数と可変長引数 `..<`
* スプレッド引数とオプショナル引数 `?<`
* スプレッド引数とデフォルト値

他の機能については重複した利用はできません。

### structの要素の高度な機能

#### ラベル

要素の名前と型のペアを記述する代わりに、文字列を置くことで「ラベル」を配置することができます。

ラベルは、structの要素としてそのラベルと一致する文字列を含むことを要求します。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct LabelElementSample 
    a
    b
    c
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(a c b)
</pre>
        </td>
    </tr>
</table>

この例では、ラベル`a`, `b`, `c`すべてを含むことが要求されています。

#### 配列ラベル

要素の名前と型のペアを記述する代わりに、要素名のみの配列を置くことで「配列ラベル」を配置することができます。

配列ラベルは、structの要素としてそのラベルと一致する文字列一つのみからなる配列を含むことを要求します。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct ArrayLabelElementSample 
    (a)
    (b)
    (c)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
((a) (c) (b))
</pre>
        </td>
    </tr>
</table>

この例では、ラベル`(a)`, `(b)`, `(c)`すべてを含むことが要求されています。

ラベルと配列ラベルは、それ単体で使用することはあまりなく、基本的にオプショナルなラベルや可変長のラベルとして使います。

#### オプショナル要素 `?`

要素名に`?`のサフィックスをつけると、その要素が省略可能になります。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct OptionalElementSample
    (title String)
    (description? String)  
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(
    (title オプショナル要素サンプル)
)
</pre>
        </td>
    </tr>
</table>

この例では、`description`が省略されています。

#### 可変長要素 `..`

要素名に`?`のサフィックスをつけると、その要素が可変長になります。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct VariableElementSample
    (title String)
    (tag.. String)  
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(
    (title 可変長要素サンプル)
    (tag タグ1)
    (tag タグ2)
)
</pre>
        </td>
    </tr>
</table>

この例では、「タグ1」と「タグ2」の2つが`tag`として指定されています。

#### スプレッド要素 `<`

要素名に`<`のサフィックスをつけることで、その型の情報をキーの記述なしでそのまま要素として記述することができるようになります。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct SpreadArgumentSample
    (user_name String)
    (page< WebPageStruct)
)

(struct WebPageStruct
    (title String)
    (url Url)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(
    (user_name shohei)
    (
        (title "Example Domain")
        (url http://example.com)
    )
)
</pre>
        </td>
    </tr>
</table>

この例では、ユーザー名とそのウェブページに関する情報について、`page`キーなしで値を直接`struct`の要素として記述しています。

#### structのマージ `<<`

要素名に`<<`のサフィックスをつけることで、その`struct`の型のキーと値のペアをマージして記述することが可能です。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct SpreadArgumentSample
    (user_name String)
    (page<< WebPageStruct)
)

(struct WebPageStruct
    (title String)
    (url Url)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(
    (user_name shohei)
    (title "Example Domain")
    (url http://example.com)
)
</pre>
        </td>
    </tr>
</table>

この例では、ユーザー名とそのウェブページに関する情報について、フラットな`struct`のように記述しています。

#### デフォルト値

要素の名前と型の、次の要素として値を記述することで、その引数は省略可能となり省略時のデフォルト値としてその値が使用されます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(struct RgbaColorStruct
    (red UInt8)
    (green UInt8)
    (blue UInt8)
    (alpha UInt8 255)
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(
    (red 255) 
    (green 220)
    (blue 200)
)
</pre>
        </td>
    </tr>
</table>

この例では`alpha`の値が省略されており、代わりにデフォルト値の`255`が使われます。

#### 各機能の複合的な利用

structの要素の高度な機能に以下の組み合わせについては重複した利用が可能です

* オプショナルラベル
* 可変長ラベル
* スプレッド要素と可変長要素 `..<`
* スプレッド要素とオプショナル要素 `?<`
* スプレッド要素とデフォルト値

他の機能については重複した利用はできません。

### enumの列挙子の高度な機能

#### タプル列挙子 `:`

列挙子名に`:`サフィックスをつけることで、列挙子の配列の第一要素に自由な引数またはラベルを設定できるようになります。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(enum NumberOperation
    (addition:       (number0 Float64) + (number1 Float64))
    (subtraction:    (number0 Float64) - (number1 Float64))
    (multiplication: (number0 Float64) * (number1 Float64))
    (division:       (number0 Float64) / (number1 Float64))
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

この例では、`Operation.addition`の列挙子名は`addition`ですが第一要素が`(number0 Float64)`になるように指定しています。

#### スプレッド列挙子 `<`

列挙子名に`<`サフィックスをつけることで、その1つ目の引数がそのまま列挙子の値として使われます。

<table>
    <tr><th>IDL</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="lisla">
(enum Expression
    (number< (number Float64))
    (operation< (operation Operation))
)

(enum Operation
    (addition:       (expr0 Expression) + (expr1 Expression))
    (subtraction:    (expr0 Expression) - (expr1 Expression))
    (multiplication: (expr0 Expression) * (expr1 Expression))
    (division:       (expr0 Expression) / (expr1 Expression))
)
</pre>
        </td>
        <td>
<pre lang="lisla">
(1.5 + (3.5 * 4.5))
</pre>
        </td>
    </tr>
</table>

`Expression`型は、列挙子として浮動小数点数または`Operation`をとります。これにより自由にネストが可能な四則演算の計算式を表現しています。

#### 各機能の複合的な利用

enumの列挙子の高度な機能は重複した利用はできません。

## 相互変換性

Lisla IDLによってLisla文書の構造の明確化する目的の1つに、Lisla文書とプログラムの内部データとの相互変換があります。

この相互変換というのは、以下の2つの方向の変換のことです。

* Lislaのテキストファイルから、プログラムの内部データへの変換
* プログラムの内部データから、Lislaのテキストファイルへの変換

Lisla IDLはこの2方向の変換を行った場合に、データが欠損したり、壊れたりしないことを保証するために、各機能にはいくつかの制限が加えられます。

例えば以下のようなものです。

* 条件の重複するenumの列挙子の禁止
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

使用頻度の高い型について、標準のIDLライブラリとして提供しています。

[Lisla IDL 標準ライブラリ](../../../data/idl/std)

### Lisla IDL の IDL

Lisla IDL自身についてもLisla IDLによる文書構造の定義がされており、これも標準ライブラリに含まれています。

[lisla/idl.idl.lisla](../../../data/idl/std/lisla/idl.idl.lisla)

## コーディング規約

### 命名

原則として以下の記法の使用を推奨しています。

* 型名: PascalCase
* 引数名: snake_case
* 列挙子名: snake_case
* `struct`の要素名: snake_case

列挙子名と`struct`の要素名は、実際の文書構造に影響を与えます。このため実際の文書の都合上、この規約にしたがえない場合は実際の文書の都合を優先してかまいません。

ただし、hxlislaではHaxeのソースコードを出力する時に、Haxeのコーディング規約にあった変数名などに変換して出力をしているため、ケース違いの同じ名前が使用されていると正しく出力ができない場合があります。