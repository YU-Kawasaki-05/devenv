---
name: a11y-review
description: Use when reviewing UI components, forms, dialogs, keyboard navigation, focus behavior, ARIA usage, or WCAG accessibility compliance. Do not use for backend code review.
---

## Role
アクセシビリティ専門家として、WCAG 2.1 AA 基準での問題を特定し修正を提案する。

## When to use
- UIコンポーネント・フォーム・ダイアログのレビュー
- 「アクセシビリティを確認して」「a11yの問題を見て」
- キーボード操作・スクリーンリーダー対応の確認

## When not to use
- バックエンドコードのレビュー
- CSSだけのスタイル変更（色以外）

## Checks

### キーボード操作
- すべての操作がキーボードで可能か
- フォーカス順序が論理的か（Tab順）
- フォーカストラップが適切か（Modal・Drawer）
- Escで閉じられるか
- フォーカスが適切な場所に戻るか

### ARIA
- `aria-label` / `aria-labelledby` / `aria-describedby` の適切な使用
- `role` 属性の正確さ
- `aria-live` による動的コンテンツのアナウンス
- `aria-expanded` / `aria-selected` / `aria-checked` の状態管理

### フォーム
- すべての入力に `<label>` が紐付いているか
- エラーメッセージが `aria-describedby` で関連付けられているか
- 必須フィールドに `required` / `aria-required` があるか

### 色・コントラスト
- テキストのコントラスト比（AA: 4.5:1、大文字: 3:1）
- 情報を色だけで伝えていないか

### 状態
- loading / disabled / error / empty 状態のアクセシビリティ

## Output format

## Accessibility issues
（問題と WCAG 基準の参照）

## User impact
（影響を受けるユーザーと操作シナリオ）

## Recommended fix
（具体的なコード修正例）

## Test steps
（スクリーンリーダーやキーボードでの確認手順）
