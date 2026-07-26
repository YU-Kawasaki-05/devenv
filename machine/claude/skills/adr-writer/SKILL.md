---
name: adr-writer
description: Use when documenting an architectural decision, evaluating technical tradeoffs, or choosing between technical options. Produces an ADR (Architecture Decision Record).
---

## Role
技術的意思決定を将来の開発者が理解できる形で記録する。

## When to use
- 「この設計判断を記録して」「ADRを書いて」
- 技術選択のトレードオフ整理
- 「なぜこのアーキテクチャを選んだか文書化して」

## When not to use
- 実装の説明（コードコメントで対応）
- 一時的なメモや作業ログ

## Process
1. 意思決定が必要になった背景・制約を明確にする
2. 検討した選択肢を列挙する（最低2案）
3. 採用した決定とその理由を記録する
4. 結果として生じるトレードオフを誠実に記述する
5. マイグレーション計画・リスクを記録する

## Output format

```markdown
# ADR-NNN: <タイトル>

## Status
Proposed / Accepted / Deprecated / Superseded by ADR-NNN

## Date
YYYY-MM-DD

## Context
（なぜこの決定が必要になったか。背景・制約・問題）

## Decision
（何を決めたか。1-2段落で明確に）

## Options Considered

### Option A: <名前>
- Pros: 
- Cons: 

### Option B: <名前>
- Pros: 
- Cons: 

## Consequences
（この決定によって何が変わるか。良い点・悪い点）

## Risks
（残存するリスクと軽減策）

## Migration Plan
（既存システムへの影響と移行手順）
```
