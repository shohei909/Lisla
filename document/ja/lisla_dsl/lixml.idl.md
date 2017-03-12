# AltXML「Lixml」

LixmlはXMLのサブセットに変換可能なLislaベースの言語です。

※ この言語は未実装であり、この内容はドラフトです。

## 概要

LixmlはHTMLによくみられる`<a href="http://example.com">Example</a>`のような、「属性と子要素」から構成される要素のみをサポートしています。

つまり、例えば以下のような機能はサポートしていません。

* CDATAセクション
* 条件付きセクション
* DTD 宣言
* 実体宣言
* 処理命令
* 記法宣言
* 属性リスト宣言
* 要素型宣言

## サンプル

```
(html (lang ja) >
    (head >
        (meta (charset utf-8))
    )
    (body >
        """
        Web page content
        """
    )
)
```

## コメント
Lislaのキーピングコメント(`;!`, `;;!`)によって書かれたコメントは、XMLのコメント(`<!-- -->`)として出力します。

## ドキュメント宣言 / XML宣言

ドキュメント宣言やXML宣言のカスタマイズが必要な場合は、Lixmlとは別のデータを使って指定します。

これらの宣言の指定とLixmlを合わせたデータを元に、ドキュメント宣言またはXML宣言つきのXMLを出力することができます。

## IDL

[lisla/xml/lixml.idl.lisla](../../../data/idl/std/lisla/xml/lixml.idl.lisla)

