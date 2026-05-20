---
name: company-research
description: Use when the user wants to research a company for job hunting. Searches the web and saves structured results to companies/<path>/research.md. Trigger on "企業調べて", "〇〇会社の情報", "企業リサーチ", "会社について調べて".
---

# 企業リサーチ

## Role

企業情報をWebサーチで収集し、就活に必要な形で構造化・保存する。

## When to use

- 「〇〇という会社を調べて」「企業リサーチして」
- 「企業情報をまとめて」「会社のことを知りたい」
- 応募前・ES作成前・面接準備前の情報収集

## When not to use

- 書類を書くとき（→ `doc-writer`）
- 面接準備をするとき（→ `interview-prep`）

## ディレクトリ構造のルール

**`<path>` は以下の2パターン:**

| 企業タイプ | パス形式 | 例 |
|-----------|---------|-----|
| 単一エンティティ（部門不要） | `companies/<会社名>/` | `companies/LayerX/` |
| グループ企業・複数部門に応募 | `companies/<グループ名>/<部門名>/` | `companies/PwC/コンサルティング/` |

グループ企業の場合は `companies/<グループ名>/_overview.md` にグループ共通情報を置く（任意）。

## Process

1. ユーザーから企業名・業種・志望職種・部門（あれば）を確認
2. **グループ/部門の判断**: 同一グループの複数部門に応募するか確認してパスを決定
3. Web検索で以下を収集:
   - 事業内容・主要サービス・競合との差別化
   - 企業文化・バリュー・求める人物像（採用ページ重視）
   - 直近のニュース・トピック・成長領域
   - 採用情報（職種・待遇・選考フロー）
4. `companies/<path>/` ディレクトリを作成（未存在の場合）
5. `companies/<path>/research.md` に構造化して保存
6. `companies/<path>/questions.md` が未作成なら空テンプレートを作成
7. グループ企業かつ `_overview.md` 未作成なら `companies/<グループ名>/_overview.md` を作成

## Output format: companies/<path>/research.md

```markdown
# 企業リサーチ: <企業名>

調査日: YYYY-MM-DD
志望職種: <職種>

## 基本情報

| 項目 | 内容 |
|------|------|
| 業種 | |
| 設立 | |
| 規模（従業員数） | |
| 上場区分 | |
| 本社所在地 | |

## 事業内容

（主要事業・サービス・競合との差別化）

## 企業文化・バリュー

（ミッション・ビジョン・バリュー・社風）

## 求める人物像

（採用ページ・求人票から抜粋）

## 最近のニュース・トピック

- YYYY-MM: ...

## 採用情報

- 募集職種:
- 待遇:
- 勤務地:
- 選考フロー:

## 志望度・気になる点

（自分の感想・深掘りしたい疑問）
```

## Output format: companies/<path>/questions.md

```markdown
# 設問一覧: <企業名>

## 提出書類の設問

| # | 書類種別 | 設問文 | 字数制限 | 対応ファイル |
|---|---------|--------|---------|------------|
| 1 | ES | | | entries/es_v1.md |

## 面接で聞かれた質問

（面接後に追記）
```
