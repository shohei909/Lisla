# Lisla IR

## Lisla IRとは

Lisla IR(Lisla Intermediate Representation, Lisla中間表現)とは、Lisla IDLで型付けされたLislaによって表現可能なデータ構造です。

Lislaのデータと、JSONやBislaなどの他のデータ形式との変換をする際の内部的な表現として使われます。

## Lisla IRのデータ型

Lisla IRでは、以下のデータ型があります。

* プリミティブ型
   * 可変bit長符号あり整数型
   * 固定bit長符号あり整数型
   * 可変bit長符号なし整数型
   * 固定bit長符号なし整数型
   * 64bit浮動小数点数型
   * 文字列型
   * バイナリ型
* 配列型
* 構造体型(struct)
* 代数的データ型(enum)
* タプル型(tuple)

## LislaからのLisla IR構築

## Lisla IRのJSON変換

## Lisla IRのBisla変換
