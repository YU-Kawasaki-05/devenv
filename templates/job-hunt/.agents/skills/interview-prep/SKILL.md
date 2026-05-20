---
name: interview-prep
description: Use when the user wants to prepare for a job interview or record post-interview notes. Generates expected questions and draft answers based on company research and submitted documents. Trigger on "面接の準備", "想定質問を出して", "面接練習", "面接が終わった", "面接メモを残したい".
---

# 面接準備

## Role

企業情報と提出済み書類を踏まえた面接準備をサポートし、面接後のメモ記録も行う。

## When to use

- 「面接の準備をしたい」「想定質問を出して」
- 「面接練習をしたい」「回答を磨きたい」
- 「面接が終わった。メモを残したい」

## Mode

ユーザーの発言から以下の2モードを判断して実行する:

- **準備モード**: 面接前。想定Q&A生成 → `interview/prep.md` に保存
- **記録モード**: 面接後。実際の質問・手応え・気づきを `interview/log.md` に追記

## Process（準備モード）

1. 企業名・選考段階（一次・二次・最終）を確認
2. 以下を読み込む（存在するものすべて）:
   - `companies/<path>/research.md`（`<path>` は単体企業なら `<会社名>`、グループ企業なら `<グループ名>/<部門名>`）
   - `companies/<path>/entries/`（提出済み書類）
   - `self/strengths.md` と `self/experiences/`
3. 想定質問を生成:
   - 必須：自己紹介・志望動機・自己PR・ガクチカ・長所短所・逆質問
   - 企業固有：研究・事業理解・職種別の深掘り
4. 各質問への回答案を `self/` の素材ベースで作成
5. `companies/<path>/interview/prep.md` に保存

## Process（記録モード）

1. 企業名・面接日・選考段階を確認
2. ユーザーから実際の質問・回答・手応えをヒアリング
3. `companies/<path>/interview/log.md` に追記

## Output format: interview/prep.md

```markdown
# 面接準備: <企業名> — <選考段階>

作成日: YYYY-MM-DD

## 必須質問と回答案

### 自己紹介（1〜2分）

### 志望動機

### 自己PR / 強み

### ガクチカ（学生時代に力を入れたこと）

### 弱み・改善点

### キャリアビジョン（5年後・10年後）

### 逆質問（3問）
1.
2.
3.

## 企業固有の深掘り想定

## 注意点・当日の準備メモ
```

## Output format: interview/log.md

```markdown
# 面接記録: <企業名>

## <選考段階> — YYYY-MM-DD

### 実際に聞かれた質問
1. <質問> → <回答の要点>

### 手応え・気になった点

### 次回への改善点

---
```
