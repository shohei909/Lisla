# ArrayTree DSL ツールキット

ArrayTree DSL ツールキットは、LislaベースのDSLを簡単に作成するためのツール群です。

IDL on ArrayTree を使ってデータ構造を記述するだけでDSLの作成が終わり、パーサ、バリデータ、シンタックスハイライタ、入力補完を手に入れることができます。


# 構成

ArrayTree DSL ツールキットは以下のツールで構成されます。


## Rust

### libarraytree
RustでLislaをあつかうためのライブラリです

#### 機能

- [ｘ] Lisla読み込み
- [ ] Lisla書き込み
- [ ] フォーマット
- [ ] データ正規化
- [ ] Hash生成
- [ ] ファイル圧縮(minify)
- ArrayTree IDL
    - Rust出力
        - [ ] データ構造生成
        - オブジェクトマッピング
            - [ ] データ構造生成
            - [ ] パーサー生成 
    - エディタ補助
        - [ ] シンタックスハイライト
        - [ ] コードジャンプ
        - [ ] 入力補完

### arraytreec
Lislaのためのコマンドラインツール

#### 機能
- [ ] ArrayTree → Json変換
- [ ] ファイル圧縮(minify)
- [ ] フォーマット
- [ ] バリデーション

- 言語サーバー
    - [ ] シンタックスハイライト
    - [ ] コードジャンプ
    - [ ] 入力補完
    - [ ] プラグインシステム
    - プラグイン
        - [ ] ArrayTree IDL サポート強化

- IDL on ArrayTree
    - 標準ライブラリ

## Haxe

### hxarraytree
HaxeでLislaをあつかうためのライブラリです。

#### 機能
- [x] Lisla読み込み
- [ ] Lisla書き込み
- [ ] データ正規化
- [ ] Hash生成

- ArrayTree IDL
    - ArrayTree → Haxe 出力
        - [x] データ構造
        - [ ] 逆Lisla化
        - [ ] Lisla化
        - [ ] 逆Bisla化
        - [ ] Bisla化
    - [ ] Haxe → ArrayTree 出力

## エディタ

### ArrayTree VSCode Plugin
Visual Studio Code上で、Lislaを記述するためのプラグイン

#### 機能
- [ ] フォーマット
- [ ] シンタックスハイライト
- [ ] バリデーション
- [ ] コードジャンプ
- [ ] 入力補完

### さまざまなLisla DSL

ArrayTree 

#### ArrayTree IDL

#### Clidl (Command Line Interface language)

Clidlはコマンドラインのインターフェスを記述する言語です。

#### Lixml
