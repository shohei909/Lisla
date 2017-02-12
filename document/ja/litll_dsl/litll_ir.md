# Litll IR

## Litll IRとは

Litll IR(Litll Intermediate Representation, Litll中間表現)とは、Litll IDLで型付けされたLitllによって表現可能なデータ構造です。

Litllのデータと、JSONやBitllなどの他のデータ形式との変換をする際の内部的な表現として使われます。

## Litll IRのデータ型

Litll IRでは、以下のデータ型があります。

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

## LitllからのLitll IR構築

## Litll IRのJSON変換

## Litll IRのBitll変換
