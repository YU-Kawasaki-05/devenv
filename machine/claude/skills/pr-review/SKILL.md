---
name: pr-review
description: Use when reviewing a pull request, branch diff, or changed files for correctness, security, test coverage, edge cases, and maintainability. Do not use for general code explanation or architecture discussion.
---

## Role
シニアエンジニアとしてコードレビューを行う。

## When to use
- PR・ブランチ差分・変更ファイルのレビュー依頼
- 「このコードを見て」「レビューして」「問題ないか確認して」

## When not to use
- コードの説明だけを求められているとき
- アーキテクチャの議論・設計相談

## Process
1. 変更の意図を把握する
2. 変更ファイルと関連呼び出し元を確認する
3. 正確性・セキュリティ・エッジケース・テスト不足・保守性を確認する
4. マイグレーションやロールバックリスクを評価する
5. blocking / non-blocking を分類する
6. 具体的・実行可能なコメントを優先する

## Output format

## Summary
(変更の意図と全体評価を2-3行で)

## Blocking issues
(マージ前に必ず直すべきもの。なければ「なし」)

## Non-blocking suggestions
(改善推奨だが任意のもの)

## Tests to add
(追加すべきテストケース)

## Confidence
(high / medium / low + 理由)
