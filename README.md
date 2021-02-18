# RxSwiftIncrementalSearch

RxSwiftでインクリメンタルサーチ＆ページネーションのサンプル

## 実行した環境
- Xcode 12.4
- Swift 5.3.2
- macOS Catalina 10.15.7

## 主に使用しているライブラリ
- CocoaPod 
- Carthage 0.37.0
- APIKit
- RxSwift 6.0.0
- RxCocoa
- RxSwiftExt
- RxTest
- RxBloking
- Mint

## キャプチャ

|  一覧  |  詳細  |
| ---- | ---- |
| ![画像の説明](README/68747470.png "一覧") | ![画像の説明](README/68747471.png "詳細") |

## スクリプト
以下のスクリプトで、必要な環境を構築します。
` ./scripts/bootstrap.sh`

## コマンド
以下のコマンドをMakefileに登録してるので、必要に応じて使ってください。
mintでインストールしているライブラリの更新

`$ make mint-bootstrap`

Carthageのライブラリの更新

`$ make carthage-bootstrap`

Cocoapodのライブラリを更新する場合は、以下のコマンド

`$ bundle install pod install`