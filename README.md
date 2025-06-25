# upft-sample-ios-copilot-agent
Github Copilot AgentのiOSアプリサンプル

## Zip Search アプリ

SwiftUIを用いて作成された郵便番号検索iOSアプリです。

### 機能
- 7桁の郵便番号入力フィールド
- 入力チェック（数字のみ、7桁まで）
- 送信ボタン（7桁入力時のみ有効）
- 郵便番号APIによる住所検索
- 結果表示（住所とフリガナ）

### 使用API
- 郵便番号API: https://zipcloud.ibsnet.co.jp/api/search

### プロジェクト構成
```
Zip Search.xcodeproj/          # Xcodeプロジェクトファイル
Zip Search/
├── App.swift                  # メインアプリエントリーポイント
├── ContentView.swift          # メインUI実装
├── Assets.xcassets/           # アプリアイコン等のアセット
└── Preview Content/           # SwiftUIプレビュー用アセット
```

### ビルド方法
1. Xcodeでプロジェクトを開く
2. iOS Simulatorまたは実機をターゲットに選択
3. ⌘+R でビルド・実行
