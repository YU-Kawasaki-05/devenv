---
name: doc-writer
description: Use when the user wants to write any job application document: entry sheets (ES), motivation letters, self-introductions, cover letters, or answers to company-specific questions. Always reads self/ materials before writing. Saves output with version numbers under entries/. Trigger on "ESを書いて", "設問に答えて", "志望動機を作って", "書類を書きたい".
---

# 書類作成

## Role

`self/` の自己分析素材を活用して、設問・書類種別に応じた回答を作成・バージョン管理しながら保存する。

## When to use

- 「ESを書いて」「設問に答えて」「志望動機を作って」
- 「自己PRを書いて」「〇〇会社の書類を作りたい」
- 既存書類を改善したいとき

## When not to use

- 自己分析そのものをしたいとき（→ `self-analysis`）
- 企業情報が足りないとき（先に `company-research` を実行）

## Process

1. 企業名・書類種別・設問内容・字数制限をユーザーから確認
2. `self/` の全ファイルを読み込む（**必須**）
3. `companies/<path>/research.md` があれば読み込む（`<path>` は単体企業なら `<会社名>`、グループ企業なら `<グループ名>/<部門名>`）
4. `companies/<path>/entries/` の既存ファイルを確認:
   - 初回: `_v1` から作成
   - 改善版: 最新バージョンを参照して `_v<N+1>` を作成
5. 設問の字数制限・意図を分析してから下書きを作成
6. ユーザーと確認・修正（字数・表現・内容の調整）
7. 合意した内容を `companies/<path>/entries/<type>_v<N>.md` に保存

## バージョン管理ルール

- 最初は `_v1`、改善のたびに `_v2`, `_v3` と増やす
- **既存バージョンを絶対に上書きしない**
- 改善版には前バージョンからの変更点・理由を記録する

## 書類の種別

| type 値 | 書類種別 |
|---------|---------|
| `es` | エントリーシート（設問回答） |
| `motivation` | 志望動機書 |
| `self_pr` | 自己PR |
| `resume` | 履歴書（共通書類は `docs/` に保存） |
| `other` | その他（cover letter 等） |

## Output format: entries/<type>_v<N>.md

```markdown
---
type: <es|motivation|self_pr|other>
company: <企業名>
question: <設問文>
char_limit: <字数制限。なければ null>
version: <N>
created: YYYY-MM-DD
---

# <書類種別> v<N> — <企業名>

## 設問

<設問全文>

## 回答

<回答本文>

## 改善メモ（v2以降）

前バージョン（v<N-1>）からの変更:
- <変更点と理由>
```
