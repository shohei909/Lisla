# Lisla DSL ツールキット

Lisla DSL ツールキットは、LislaベースのDSLを簡単に作成するためのツール群です。

IDL on Lisla を使ってデータ構造を記述するだけでDSLの作成が終わり、パーサ、バリデータ、シンタックスハイライタ、入力補完を手に入れることができます。


# 構成

Lisla DSL ツールキットは以下のツールで構成されます。


## Rust

### liblisla
RustでLislaをあつかうためのライブラリです

#### 機能

- [ｘ] Lisla読み込み
- [ ] Lisla書き込み
- [ ] フォーマット
- [ ] データ正規化
- [ ] Hash生成
- [ ] ファイル圧縮(minify)
- Lisla IDL
    - Rust出力
        - [ ] データ構造生成
        - オブジェクトマッピング
            - [ ] データ構造生成
            - [ ] パーサー生成 
    - エディタ補助
        - [ ] シンタックスハイライト
        - [ ] コードジャンプ
        - [ ] 入力補完

### lislac
Lislaのためのコマンドラインツール

#### 機能
- [ ] Lisla → Json変換
- [ ] ファイル圧縮(minify)
- [ ] フォーマット
- [ ] バリデーション

- 言語サーバー
    - [ ] シンタックスハイライト
    - [ ] コードジャンプ
    - [ ] 入力補完
    - [ ] プラグインシステム
    - プラグイン
        - [ ] Lisla IDL サポート強化

- IDL on Lisla
    - 標準ライブラリ

## Haxe

### hxlisla
HaxeでLislaをあつかうためのライブラリです。

#### 機能
- [x] Lisla読み込み
- [ ] Lisla書き込み
- [ ] データ正規化
- [ ] Hash生成

- Lisla IDL
    - Lisla → Haxe 出力
        - [x] データ構造
        - [ ] 逆Lisla化
        - [ ] Lisla化
        - [ ] 逆Bisla化
        - [ ] Bisla化
    - [ ] Haxe → Lisla 出力

## エディタ

### Lisla VSCode Plugin
Visual Studio Code上で、Lislaを記述するためのプラグイン

#### 機能
- [ ] フォーマット
- [ ] シンタックスハイライト
- [ ] バリデーション
- [ ] コードジャンプ
- [ ] 入力補完

### さまざまなLisla DSL

Lisla 

#### Lisla IDL

#### Clidl (Command Line Interface language)

Clidlはコマンドラインのインターフェスを記述する言語です。

#### Lixml
