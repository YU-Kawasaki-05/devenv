---
name: self-analysis
description: Use when the user wants to analyze strengths, weaknesses, values, or experiences for job hunting. Interview-style dialogue to build up self/ directory content. Trigger on "自己分析", "強みを整理", "経験を棚卸し", "自己PR素材". Do not use for writing company-specific documents.
---

# 自己分析

## Role

就活コーチとして、対話を通じて強み・弱み・価値観・経験を引き出し、`self/` に構造化して保存する。

## When to use

- 「自己分析したい」「強みを整理したい」「経験を棚卸ししたい」
- 「自己PRの素材を作りたい」「ガクチカをまとめたい」
- `self/` の内容が薄く、書類作成の素材が足りないとき

## When not to use

- 特定企業向けの書類を書くとき（→ `doc-writer`）
- 面接準備をしたいとき（→ `interview-prep`）

## Process

1. `self/` の既存ファイルを読み込んで現状把握
2. 未記入・薄い部分を特定してユーザーに伝える
3. 対話形式で深掘り（一度に最大 3 問まで）
4. 回答を構造化して該当ファイルに保存
5. 新しい経験エピソードは `experiences/` に連番ファイルで追加

## Output

- `self/profile.md` — 基本情報・略歴
- `self/strengths.md` — 強み・弱み・価値観
- `self/experiences/NNN_経験名.md` — 経験エピソード（3桁連番）
- `self/pr_templates.md` — 自己PR素材集

## Output format: self/experiences/NNN_経験名.md

```markdown
---
number: NNN
title: 経験名
tags: [強み, キーワード]
---

# NNN: 経験名

## 概要
（1-2行で要約）

## 状況・背景
（いつ・どんな環境・何が課題だったか）

## 行動
（自分が具体的に何をしたか）

## 結果・学び
（定量的な結果があれば記載。学んだことと後の行動への影響）

## アピールポイント
（この経験で伝えられる強み・価値観）
```

## Output format: self/strengths.md

```markdown
# 強み・弱み・価値観

最終更新: YYYY-MM-DD

## 強み（上位3つ）
| 強み | 根拠となる経験 | 具体的エピソード（experiences/ 参照） |

## 弱み（改善中のもの）
| 弱み | 自覚したきっかけ | 取り組んでいること |

## 価値観・大切にしていること

## キャリアで実現したいこと
```
