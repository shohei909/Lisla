# 型定義フォーマット : type.arraytree

`type.arraytree` はLislaの型定義フォーマットで、JSONに対するJSON Schemaに近い概念です。

Lislaと`type.arraytree`を合わせて使うことで、以下のような機能を得ることができます。

* JSON, Protocol Buffersへの相互変換
    * JSON Schemaの出力
    * Protocol Buffersの型定義ファイル（.proto）の出力
* エディタでの入力補完
* より詳細なシンタックスハイライト
* バリデーション
<!--
    追加予定の機能
    * データのシリアライズ/逆シリアライズのコード生成(Rust) 
-->

## 簡単な例

`type.arraytree` で型を定義する簡単な例を見ていきます。

<table>
    <tr><th>type.arraytree</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="arraytree">
(newtype Row : (Array String))
</pre>
        </td>
        <td>
<pre lang="arraytree">
(a b c d)
</pre>
        </td>
    </tr>
</table>

`(newtype Row : (Array String))` という文に出てきた要素を、一つずつ見ていきます。

* `newtype`は、新しい型を宣言するためのラベルです。
* `Row`は、新しい型の名前です。
* `:`はラベルです。`newtype`の宣言では、型名と元になる型の間にこのラベルをはさむ必要があります。
* `(Array String)`は、`Row`の構造のもとになる型です。
   * `Array`は配列の型です。トップレベルの基本型で、引数を1つ持ちます。
       * 引数を持つ型は、配列の第一要素に型名を書き、第二要素以降に引数の情報を書きます
   * `String`は文字列の型です。トップレベルの基本型で、引数は持ちません。
       * 引数を持たない型は、単なる文字列として型名を書きます。

つまり、`(newtype Row : (Array String))`は「`Row`という名前で`(Array String)`の構造を持つ新しい型を作る」という意味です。

このように定義した、`Row`型はまた別の型を構成するために使うことができます。

<table>
    <tr><th>type.arraytree</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="arraytree">
(newtype Table : (Array Row))
</pre>
        </td>
        <td>
<pre lang="arraytree">
(
    (a b c d)
    (e f g h)
    (i j k l)
)
</pre>
        </td>
    </tr>
</table>

`type.arraytree` 自体の型記述が、 `type.arraytree` で行われているため、より大きいサンプルを見たい場合は、[そちら](../../../data/idl/lib/arraytree/type.type.arraytree) を見てください。

## 5種類のユーザー定義型

`type.arraytree`では、以下の5種類の型が使えます

* newtype
* tuple
* struct
* enum
* union

### newtype (新しい型)

`newtype`は、ほかの型をもとにして同じ構造を持つ新しい型を作ります。

<table>
    <tr><th>type.arraytree</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="arraytree">
(newtype Url : String)
</pre>
        </td>
        <td>
<pre lang="arraytree">
http://example.com
</pre>
        </td>
    </tr>
</table>

例えば、上記のように、`String`を元にした新しい型`Url`型を作ることで、型定義を読んだ人やプログラムがそれが具体的にどういう意味の文字列なのかを認識しやすくなります。


### tuple (タプル構造体の型)

`tuple`は、タプル構造体の型を作ります。

タプル構造体は、各要素ごとに要素名と型を定義した配列です。

<table>
    <tr><th>type.arraytree</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="arraytree">
(tuple Link
    (var title : String)
    (var url : Url)
)
</pre>
        </td>
        <td>
<pre lang="arraytree">
("Example Domain" http://example.com)
</pre>
        </td>
    </tr>
</table>

この例の場合、1つ目の要素の名前が`title`で型が`String`、2つ目の要素の名前が`url`で型が`Url`です。タプル構造体`Link`はこの2つの要素で構成される配列です。

また、タプル構造体のもつ、型と名前が指定された各要素のことを「引数（argument）」と呼びます。

### struct (構造体の型)

`struct`は、構造体の型を作ります。

構造体はキーと値のペアの配列で、各キーに対する型が定義されています。

<table>
    <tr><th>type.arraytree</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="arraytree">
(struct LinkStruct
    (var title : String)
    (var url : Url)
)
</pre>
        </td>
        <td>
<pre lang="arraytree">
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

列挙体は、型に定義された文字列のうち、いずれかの文字列をとります。

<table>
    <tr><th>type.arraytree</th><th>データ例</th></tr>
    <tr>
        <td>
<pre lang="arraytree">
(enum Boolean
    (case true)
    (case false)
)
</pre>
        </td>
        <td>
<pre lang="arraytree">
true
</pre>
        </td>
    </tr>
</table>

この例では、`true`または`false`のどちらかを値として持つ`Boolean`型を定義しています。

### Union (直和型)

`union`は直和型です。

直和型はいくつかの型をもち、そのいずれかの型をとります。

<table>
    <tr><th>type.arraytree</th><th>データ例1</th><th>データ例2</th></tr>
    <tr>
        <td>
<pre lang="arraytree">
(union BoolOrLink
    (case Bool : Boolean)
    (case Link : LinkStruct)
)
</pre>
        </td>
        <td>
<pre lang="arraytree">
true
</pre>
        </td>
        <td>
<pre lang="arraytree">
(
    (url http://example.com)
    (title "Example Domain")
)
</pre>
        </td>
    </tr>
</table>


直和型が `case` として取りうる型には2つの制限があります
1. 互いに取りうる値が衝突するような、複数の型を定義することはできません。
2. 配列または要素1つ以上持つタプルと、要素1つ以上持つ構造体を同時に `case` として持つことができない。



## 型の引数

## その他の制限

## `type.arraytree` のモジュールシステム

### ライブラリ

### モジュール

### パッケージ

## 標準ライブラリ

使用頻度の高い型について、標準ライブラリとして提供しています。

[標準ライブラリ](../../../data/idl/standard)

### `arraytree` ライブラリ

`arraytree` 自体の情報をあつかうためのライブラリとして、arraytreeライブラリを提供しています。

[arraytree ライブラリ](../../../data/idl/lib/arraytree/type.type.arraytree)

`type.arraytree` 自身の型定義も、arraytreeライブラリに含まれます。

## コーディング規約

### 命名
