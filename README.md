# Ruumarker 
（ルーマーカー）

<img src="./app/assets/images/logo.png" width="120px">

## サイトリンク

https://ruumarker.herokuapp.com/

## 利用方法

https://ruumarker.herokuapp.com/help

## サービス概要

引越しした時、不動産管理者に入居時の部屋の状況を報告するための書類を作成するためのサービスです。 

キズの位置とその写真が載っている「入居時チェック表」を作成してPDFでダウンロードできます。

もし既にキズがあった場合に、自分の過失でないことをあらかじめ説明しておけば、不当な修繕費の請求を避けられるかもしれません。

## インストール

```shell
bin/setup
yarn
bin/dev
```
## リント
```shell
# JavaScript
yarn lint 

# Ruby
bundle exec rubocop

# bundler-audit
bundle exec bundler-audit --update

# Brakeman
bundle exec brakeman -q -w2 
```

## テスト
```shell
bundle exec rspec
```

## production環境での実行（未検証）
別途AWS S3の認証情報が必要なので、完全別環境での動作確認はしていませんが、参考のために手順を記載します。

```shell
# 本番環境のDBを設定する

# 元プロジェクトの秘密情報を削除
rm -rf config/credentials.yml.enc

# AWSの認証情報を入力する
EDITOR="vi" bin/rails credentials:edit

# Node.jsとRailsの環境をproductionにする
export NODE_ENV=production
export RAILS_ENV=production

# production環境でWebpackを実行する
yarn webpack --config webpack.config.js

# アセットプリコンパイルを実行する
bin/rails assets:precompile

# プリコンパイルしたアセットを読むための設定
export RAILS_SERVE_STATIC_FILES=true

# Raisのサーバーを起動する
bin/rails server -p 3001
```
再びdevelopment環境で実行する場合は設定を戻す必要があります。
```shell
# プリコンパイルしたアセットを消去する
setopt localoptions rmstarsilent
rm -rf public/assets/.*
rm -rf public/assets/*
rm -rf tmp/cache/assets/sprockets

# Node.jsとRailsの環境をdevelopmentにする
export NODE_ENV=development
export RAILS_ENV=development

# サーバー起動する
yarn
bin/dev
```
