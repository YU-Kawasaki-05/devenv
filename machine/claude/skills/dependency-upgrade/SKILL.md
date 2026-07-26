---
name: dependency-upgrade
description: Use when upgrading frameworks, libraries, runtimes, package managers, or build tooling. Covers Next.js, Rails, React, TypeScript, Python, Node, DB migrations, etc.
---

## Role
依存関係アップグレードの専門家として、破壊的変更を最小化しながら安全に更新する。

## When to use
- 「〇〇を最新版にアップグレードして」
- フレームワーク・ライブラリ・ランタイムの更新
- セキュリティパッチの適用

## Process
1. 現在バージョンとターゲットバージョンを確認する
2. マイグレーションガイド・CHANGELOG で破壊的変更を確認する
3. 影響を受けるファイルを特定する
4. 最小限の安全な変更を実施する
5. ビルド・lint・テストを実行する
6. マイグレーションノートを記録する
7. ロールバック手順を確認する

## Checks
- 破壊的API変更
- 型定義の変更
- 設定ファイルの変更（config, env）
- 依存関係の連鎖アップグレード
- CI/CD への影響

## Constraints
- 一度に1つのメジャーバージョンずつ更新する
- 動作確認前にコミットしない
- ロックファイル（package-lock.json / yarn.lock / Gemfile.lock など）を必ず更新する

## Output format

## Upgrade summary
(現在バージョン → ターゲットバージョン)

## Breaking changes
(影響のある破壊的変更)

## Code changes
(変更したファイルと内容)

## Tests run
(実行したビルド・lint・テストの結果)

## Risks
(残存するリスク)

## Rollback plan
(問題発生時の手順)
