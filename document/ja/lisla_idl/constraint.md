# Lisla IDLにおける制限事項

Lisla IDLにしたがって「プログラムの内部データをLislaに変換」した後「Lislaからプログラムの内部データに変換」を行った場合に、データの欠損や破壊がされないように、Lisla IDLにはいくつかの制限事項があります。

## 基底型とスプレッドの制限

Lisla IDLでは、newtypeを基になる型へとたどると以下5種類のいずれかの型に行きつきます。

* `String`
* `Array`
* `enum`
* `struct`
* `tuple`

このように、newtypeの基になる型へとたどることで得られる型を基底型(underlying type)とよびます。

各スプレッドの操作が可能かどうか、この基底型にしたがって判定が行われます。

### tupleとenumのスプレッド引数

基底型として以下を持つ型が、スプレッド引数として使用できます。

* `Array`
* 配列のみを値として持ちうる `enum`
* `struct`
* `tuple`

以下を基底型として持つ場合、スプレッド引数として使用できません。
* `String`
* 文字列を値として持ちうる `enum`

### enumのスプレッド列挙子

スプレッド列挙子として使用できる型に、基底型の制限はありません。

### structのスプレッド要素

スプレッド要素として使用できる型に、基底型の制限はありません。

### structのマージ要素

基底型として以下を持つ型が、マージ要素として使用できます。
* `struct`

以下を基底型として持つ場合、マージ要素として使用できません。
* `Array`
* `enum`
* `String`
* `tuple`

## 条件の重複の禁止

### `enum`の列挙子についての条件の重複の禁止

`enum`の各列挙子は、その列挙子であると判定されるための条件が重複してはいけません。

例えば、以下のような`enum InvalidSample`は不正です。

```lisla
(enum InvalidSample
    true
    (bool< Boolean)
)

(enum Boolean true false)
```

この例では、`true`という値について、`true`の列挙子の値なのか、`bool`の列挙子の値なのか判別できません。このような`enum`を定義しようとするとバリデーションエラーが発生します。


### 「条件の重複」とは何か

enumの各列挙子などで禁止されている「条件の重複」とは何か詳しく説明します。

Lisla IDLをあつかうプログラムでは、Lislaの値が`enum`のどの列挙子にマッチするかを判定する式(パターン)を生成します。

そして、2つのパターンに同時にマッチするLislaの値が存在している場合に、「条件が重複」しているとみなされてエラーが発生します。

このパターンは、いわばLislaの値の集合です。この集合すべてが互いに素である状態であればよく、いずれかの集合が交わっている場合にエラーになります。


### 列挙子から生成されるパターン

各列挙子ごとに生成されるパターンは、以下の定義における`(Set Pattern)`のデータ構造を持ちます。

```lisla
(enum Pattern
    (const (string String))        ; 特定の文字列とマッチする
    string                         ; すべての文字列とマッチする
    (array (detail ArrayPattern))  ; detailの条件を満たすの配列とマッチする
)

(struct ArrayPattern
    (min Int32)                       ; 配列の最小の長さ
    (max? Int32)                      ; 配列の最大の長さ。ただし、上限が存在しない場合あり。
    (elements (Array ElementPattern)) ; 配列の各要素に対する条件
)

(enum ElementPattern
    never                          ; あらゆる値にマッチしない
    string                         ; すべての文字列にマッチする
    (const (strings (Set String))) ; 特定の文字列にマッチする
    array                          ; すべての配列にマッチする
    always                         ; すべての値にマッチする
)

(newtype (Set T) (Array T)) ;重複なしの集合
```

つまり、配列の第1階層までについての、任意文字列、特定文字列、配列を区別するパターンが生成されます。

例えば、先ほどの`InvalidSample.bool`の列挙子に対しては以下のパターンが生成されます。

```
; trueまたはfalseの文字列にマッチするパターン
(const true)
(const false)
```

生成されるパターンついて、以下に注意してください。

* 2階層目以降のネストが深い部分についての構造は考慮されません。
* 配列の各要素の条件(`ArrayPattern.elements`)は、先頭の要素から順番に指定されます。このとき途中に可変長やオプショナルが出現すると以降の条件は考慮されません。
* `struct`をスプレッドした引数は、`struct`の持つ要素に関係なく引数長の上限なしと判断されます。ただし、下限はstructの要素数が考慮されます。

### structの要素についての制限

`enum`と同様に、各要素にマッチするかを判定するパターンが生成されて、それらのパターンを2つ同時に満たすLislaの値が存在している場合に「条件が重複」しているとみなされてエラーが発生します。

### オプショナル引数、可変長引数についての制限

以下の引数については、直後の要素との条件の重複判定が行われます。

* オプショナル引数 `?`
* 可変長引数 `..`
* `struct`のスプレッド引数
* `Array`のスプレッド引数
* 上記の引数を末尾に持つ`tuple`または`enum`のスプレッド引数

これらの直後の引数が長さ0になりうる引数だった場合、さらに後ろの引数に対しても、条件の重複判定を行います。

長さ0になりうる引数としては、以下があります。

* オプショナル引数 `?`
* 可変長引数 `..`
* 長さ0になりうる`enum`のスプレッド引数
* 長さ0になりうる`tuple`のスプレッド引数
* 長さ0になりうる`struct`のスプレッド引数
* `Array`のスプレッド引数

### `enum`をスプレッド引数に使用する場合の追加の制限

`enum`をスプレッド引数に使う場合、上記の列挙子の「条件の重複」にさらに追加の制限が発生する場合があります。

この追加の制限が発生する条件は、`enum`の**スプレッド引数より後に可変長の引数がある**場合です。

可変長の引数とは以下を指します。

* オプショナル引数 `?`
* 可変長引数 `..`
* 長さが一定ではない`enum`のスプレッド引数
* 長さが一定ではない`tuple`のスプレッド引数
* `struct`のスプレッド引数
* `Array`のスプレッド引数

`enum`のスプレッド引数より後に、上記をふくまない場合は、追加の条件は発生しません。

発生する追加の条件というのは、`enum`の各列挙子のパターンについて配列の第2以降の要素によって発生した条件が無視されるというものです。

これらを無視して生成された各パターンについて、交わりが発生した場合にバリデーションエラーが発生します。