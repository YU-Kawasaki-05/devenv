---
name: career-strategy
description: Use when researching technology disruption, industry futures, job/skill value shifts, career strategy, and best-fit industries or roles for job hunting. Always uses broad domestic and international sources, separates facts/predictions/interpretation, and saves structured outputs to notes/career-strategy/ and decisions to notes/decisions/.
---

# Career Strategy Research

## Role

技術革新、産業構造変化、職種価値、個人の市場価値、就活の業界/職種選びを調査し、`notes/career-strategy/` と `notes/decisions/` に保存する。

## Non-negotiables

- 必ずWeb検索する。記憶だけで書かない。
- 情報源は国内外を問わず幅広く見る。
- 官公庁/国際機関、シンクタンク、コンサル、企業レポート、学術、労働市場データ、反対意見/リスク指摘を混ぜる。
- 1つの情報源だけで結論を出さない。
- 事実、予測、解釈、自分への示唆を分ける。
- 日付は絶対日付で書く。
- 重要判断は `notes/decisions/` に残す。

## Directory Rules

| ファイル | 用途 |
|---|---|
| `notes/career-strategy/source-map.md` | 情報源、主張、就活への示唆、確度、URL |
| `notes/career-strategy/initial-synthesis.md` | かみ砕いた解釈、産業/職種/希少性の仮説 |
| `notes/career-strategy/personal-hypotheses.md` | `self/` と照らした個人戦略仮説 |
| `notes/career-strategy/research-backlog.md` | 次に調べる論点、未検証仮説、追加情報源 |
| `notes/decisions/DECISION_LOG.md` | 意思決定の時系列索引 |
| `notes/decisions/YYYY-MM-DD_<topic>.md` | 個別判断の背景、選択肢、決定、理由、見直し条件 |

## Research Source Portfolio

最低限、以下の種類を混ぜる。

- 公的/国際: WEF, OECD, IMF, IEA, World Bank, 内閣府, 経産省, 総務省, IPA
- シンクタンク/コンサル: McKinsey, BCG, Deloitte, PwC, Accenture, NRI, MRI, 日本総研
- 労働市場データ: LinkedIn, Lightcast, Indeed, OpenWorkなど。ただし口コミは補助扱い
- 学術/研究: Stanford HAI, MIT, Brookings, arXivの有力研究
- 反対意見: AIバブル、雇用減、電力制約、規制、セキュリティ、格差拡大

## Workflow

1. 依頼テーマを確認する: 業界未来、職種未来、スキル、個人戦略、応募判断のどれか。
2. `self/` と既存の `notes/career-strategy/` を読む。
3. Webで複数カテゴリの情報源を調べる。
4. `source-map.md` に情報源を追記/整理する。
5. `initial-synthesis.md` に、価値が上がるもの/下がるもの、業界・職種仮説を更新する。
6. `personal-hypotheses.md` に、自分にとっての応募方針・避ける条件・伸ばすスキルを更新する。
7. 方針決定があれば `notes/decisions/DECISION_LOG.md` と個別判断ファイルを更新する。

## Output Requirements

- 調査日
- 情報源一覧とURL
- 共通シグナル
- 意見が割れている点
- 自分向けの解釈
- 応募先/職種/スキルへの具体的示唆
- 未検証事項と次アクション

## Completion Report

作成/更新ファイル、追加した主要情報源、暫定結論、未検証事項を簡潔に報告する。git commitはしない。
