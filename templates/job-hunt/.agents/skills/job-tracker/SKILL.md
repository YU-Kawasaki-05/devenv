---
name: job-tracker
description: Use when the user wants to record a new job application, update selection status, check application progress, or manage deadlines. Updates tracker.md and Notion DB (if MCP is available). Trigger on "応募した", "選考が進んだ", "結果を記録", "応募状況を確認", "締切を管理".
---

# 応募管理

## Role

応募状況を `tracker.md` と Notion DB（MCP 有効時）で管理する。

## When to use

- 「〇〇に応募した」「選考が次に進んだ」
- 「結果が来た（合格/不合格）」「内定をもらった」「辞退する」
- 「応募状況を確認したい」「締切が近い会社はどこ？」

## ステータス定義

```
未応募 → 書類作成中 → 書類提出済み → 書類選考中
→ 一次面接 → 二次面接 → 最終面接
→ 内定 / 不合格 / 辞退
```

## Process

1. `tracker.md` を読み込む（存在しなければ空テンプレートで作成）
2. 操作の種類を特定:
   - **新規追加**: 企業名・職種・応募日・締切を確認して追加
   - **ステータス更新**: 企業名と新ステータスを確認して更新
   - **確認のみ**: 現在の状況を表示（ファイルは変更しない）
3. `tracker.md` を更新
4. Notion MCP が有効な場合: 対応する Notion DB のエントリも同期更新

## Notion MCP 連携

Notion MCP が有効な場合（`.codex/config.toml` の `[mcp_servers.notion]` が有効）:
- `tracker.md` 更新と同時に Notion のジョブ管理 DB を更新する
- Notion DB のページ URL を `tracker.md` の備考欄に記録する
- MCP が無効な場合は `tracker.md` のみ更新して完了

## Output format: tracker.md

```markdown
# 応募管理

最終更新: YYYY-MM-DD

## 選考中

| 企業名 | 職種 | ステータス | 締切 / 次の日程 | 備考 |
|--------|------|-----------|----------------|------|
| 〇〇株式会社 | ソフトウェアエンジニア | 書類選考中 | 2026-06-15 | |

## 完了（内定・不合格・辞退）

| 企業名 | 職種 | 結果 | 完了日 | 備考 |
|--------|------|------|--------|------|
```
