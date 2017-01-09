# Litll DSL ツールキット

Litll DSL ツールキットは、LitllベースのDSLを簡単に作成するためのツール群です。

IDL on Litll を使ってデータ構造を記述するだけでDSLの作成が終わり、パーサ、バリデータ、シンタックスハイライタ、入力補完を手に入れることができます。


# 構成

Litll DSL ツールキットは以下のツールで構成されます。


## Rust

### liblitll
RustでLitllをあつかうためのライブラリです

#### 機能
- [ｘ] Litll読み込み
- [ ] Litll書き込み
- [ ] フォーマット
- [ ] データ正規化
- [ ] Hash生成
- [ ] ファイル圧縮(minify)

- Litll IDL
    - Rust出力
        - [ ] データ構造生成
        - オブジェクトマッピング
            - [ ] データ構造生成
            - [ ] パーサー生成 
    - エディタ補助
        - [ ] シンタックスハイライト
        - [ ] コードジャンプ
        - [ ] 入力補完

### litllc
Litllのためのコマンドラインツール

#### 機能
- [ ] Litll → Json変換
- [ ] ファイル圧縮(minify)
- [ ] フォーマット
- [ ] バリデーション

- 言語サーバー
    - [ ] シンタックスハイライト
    - [ ] コードジャンプ
    - [ ] 入力補完
    - [ ] プラグインシステム
    - プラグイン
        - [ ] Litll IDL サポート強化

- IDL on Litll
    - 標準ライブラリ

## Haxe

### hxlitll
HaxeでLitllをあつかうためのライブラリです。

#### 機能
- [x] Litll読み込み
- [ ] Litll書き込み
- [ ] データ正規化
- [ ] Hash生成

- Litll IDL
    - Litll → Haxe 出力
        - [x] データ構造
        - [ ] 逆Litll化
        - [ ] Litll化
        - [ ] 逆Bitll化
        - [ ] Bitll化
    - [ ] Haxe → Litll 出力

## エディタ

### Litll VSCode Plugin
Visual Studio Code上で、Litllを記述するためのプラグイン

#### 機能
- [ ] フォーマット
- [ ] シンタックスハイライト
- [ ] バリデーション
- [ ] コードジャンプ
- [ ] 入力補完
