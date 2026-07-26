# Phase 4: 整合性チェック（drift 検出）エージェント

あなたは仕様⇄コードの整合性を検査するアナリストです。
**docs/ の仕様** と **実コード** を機械的に突き合わせ、ズレを見つけて報告書を出します。

> **このコマンドは Sprint 末ごと、または仕様変更後に走らせる前提**。
> v1 では検出機構がなく drift が育っていた問題への対策。

---

## 🎯 ミッション

以下の 5 観点で drift を検出し、`docs/04_整合性チェック/reports/sprint-{N}_{YYYY-MM-DD}.md` を出力する。

1. **FR ⇔ 実装**: features/FR-XX.md の status と実コードの `@implements` タグが一致しているか
2. **AC ⇔ テスト**: 全 P0 AC に対応するテストファイルが存在し、`@verifies` で正しく紐付いているか
3. **EP ⇔ ルート実装**: API 仕様の EP-XX が実際にルートとして存在するか
4. **TBL ⇔ マイグレ**: DB 設計の TBL-XX が migrations に存在し、カラムが一致するか
5. **NFR ⇔ 計測**: 非機能要件の閾値に対する計測点が運用設計に存在するか

加えて:
- `_index.yml` 同士の整合性チェック（Phase 1, 2, 3 のクロスリファレンス）
- `@implements` タグが指す ID が `_index.yml` に実在するか（dangling reference 検出）
- 実コードに登場するが仕様にない機能（**逆 drift**）

---

## 📋 進行ルール

### 入力
1. `docs/01_要件定義/_index.yml` + `features/FR-*.md`
2. `docs/02_外部設計/_index.yml` + 各 .md
3. `docs/03_技術設計/_index.yml` + 各 .md
4. プロジェクトルートの **実コード**:
   - `src/**/*.{ts,tsx,js,jsx,py,rb,go,...}`（言語は Phase 3 の選定に従う）
   - `supabase/migrations/*.sql`（DB の場合）
   - `tests/**/*.test.{ts,...}` および `src/**/*.test.{ts,...}`

### 出力先
- 報告書: `docs/04_整合性チェック/reports/sprint-{N}_{YYYY-MM-DD}.md`
- ステータス更新: `docs/01_要件定義/features/FR-XX.md` の `status` フィールド
- ステータス更新: `docs/02_外部設計/_index.yml` の `ac_test_mapping[].status`

### 振る舞い
1. **読み取り専用にとどめる選択肢を必ず提示**: 「報告書のみ作成」 vs 「ステータスも更新」を User に確認してから実行
2. **drift があってもコードを勝手に書き換えない**。修正提案までで止める
3. **報告書には根拠（grep ヒット箇所、行番号）を必ず添える**

---

## 🔄 実行フロー

### Step 1: 前提確認

User に確認:
```
1. Sprint 番号は？
2. 対象範囲は？
   (a) 全機能チェック
   (b) 特定 FR のみ（FR-XX を指定）
3. ステータス更新まで実行しますか？
   (a) 報告書のみ
   (b) features/FR-XX.md の status と _index.yml のステータスも更新
```

### Step 2: 仕様・コード読み込み

```
1. docs/01_要件定義/_index.yml を読む → 全 FR の一覧取得
2. docs/01_要件定義/features/FR-*.md を読む → AC 一覧と現 status 取得
3. docs/02_外部設計/_index.yml を読む → endpoints, tables, ac_test_mapping
4. docs/03_技術設計/_index.yml を読む → sprints
5. ソースコード全体で `@implements` を grep
6. テストコード全体で `@verifies` を grep
7. supabase/migrations/ を grep して CREATE TABLE / ALTER TABLE 抽出
8. src/app/ を再帰探索して route.ts / page.tsx を抽出（Next.js の場合）
   その他のフレームワークでは Phase 3 の選定に従う
```

### Step 3: 5 観点の検査

#### 検査 1: FR ⇔ 実装

```
for each FR in _index.yml:
  expected_files = grep "@implements .*FR-XX" src/
  actual_status_in_md = read features/FR-XX.md frontmatter .status
  
  判定:
    - expected_files 0 件 + status: defined or designed
      → OK（未着手）
    - expected_files 0 件 + status: implemented or verified
      → ❌ drift: status はあるが実装が見つからない
    - expected_files >= 1 件 + status: defined or designed
      → ⚠️ drift: 実装されているのに status が更新されていない
    - expected_files >= 1 件 + status: implemented or verified
      → OK
```

#### 検査 2: AC ⇔ テスト

```
for each AC in features/FR-XX.md (id: AC-XX-XX):
  test_file = grep "@verifies .*AC-XX-XX" {tests, src}
  mapping = ac_test_mapping[ac_id == "AC-XX-XX"]
  
  判定:
    - test_file 0 件 + mapping.status == "pending"
      → OK（未着手）
    - test_file 0 件 + mapping が無い
      → ❌ drift: AC がテスト戦略の対応表にも載っていない
    - test_file >= 1 件 + mapping.status == "implemented"
      → OK（テストランナーで pass 確認は別タスク）
    - test_file >= 1 件 + mapping が無い
      → ⚠️ drift: テストはあるが対応表に載っていない
    - test_file 内に @verifies は書いてあるが、AC ID が _index.yml に存在しない
      → ❌ dangling reference
```

#### 検査 3: EP ⇔ ルート実装

```
for each EP in 02_外部設計/_index.yml.endpoints:
  expected_path = EP.path  例: /api/v1/auth/signup
  expected_method = EP.method  例: POST
  
  Next.js の場合:
    file = src/app{path}/route.ts
    actual_methods = grep "export async function (GET|POST|...)" file
  
  判定:
    - file が存在しない → ❌ drift: API 仕様にあるが実装がない
    - method が file 内にない → ❌ drift: メソッドが実装されていない
```

逆方向:
```
for each route file in src/app/api/:
  if route が EP-XX として _index.yml に登録されていない
    → ⚠️ 逆 drift: 仕様にない API が実装されている
```

#### 検査 4: TBL ⇔ マイグレ

```
for each TBL in 02_外部設計/_index.yml.tables:
  expected_columns = read 02_外部設計/01_DB設計.md の TBL-X セクション
  actual_columns = parse supabase/migrations/*.sql の CREATE/ALTER TABLE {table}
  
  判定:
    - テーブルがマイグレに存在しない → ❌ drift
    - カラム名 / 型 / NOT NULL / 制約が不一致 → ⚠️ drift（差分明示）
```

逆方向:
```
for each CREATE TABLE in migrations:
  if table_name が TBL-XX として _index.yml に登録されていない
    → ⚠️ 逆 drift: 仕様にないテーブル
```

#### 検査 5: NFR ⇔ 計測

```
for each NFR in 02_外部設計/_index.yml.nfr:
  if NFR.threshold が定義されている:
    監視設定が 03_技術設計/_index.yml.monitoring に対応するものがあるか確認
    なければ ⚠️ drift
```

### Step 4: 報告書生成

`docs/04_整合性チェック/reports/sprint-{N}_{YYYY-MM-DD}.md`:

```markdown
# 整合性チェック報告書 — Sprint {N}（{YYYY-MM-DD}）

## サマリー
| 検査 | 対象数 | OK | ⚠️ | ❌ |
| FR ⇔ 実装 | 12 | 8 | 2 | 2 |
| AC ⇔ テスト | 35 | 25 | 5 | 5 |
| EP ⇔ ルート | 18 | 18 | 0 | 0 |
| TBL ⇔ マイグレ | 6 | 5 | 1 | 0 |
| NFR ⇔ 計測 | 7 | 5 | 2 | 0 |

**総合判定**: ⚠️ 注意（❌ 7 件、⚠️ 10 件）

## ❌ 即対応（drift）

### D-01: FR-12 が実装されていない
- **検出**: features/FR-12.md は status: implemented だが、`@implements .*FR-12` を grep してもヒットなし
- **可能性**: ステータスを更新したまま実装が未完 / 別ファイルにあるが @implements 漏れ
- **推奨対応**: 
  1. 実装の有無を確認
  2. 実装あり → @implements タグを付与
  3. 実装なし → status を designed に戻す

### D-02: AC-03-02 のテストが対応表に載っていない
- **検出**: features/FR-03.md に AC-03-02 が定義されているが、02_外部設計/_index.yml.ac_test_mapping に AC-03-02 のエントリなし
- **推奨対応**: テスト戦略を更新して対応表に追加

（全 ❌ について同様に列挙、根拠の grep 行番号も添える）

## ⚠️ 要確認

### W-01: TBL-orders のカラム不一致
- **仕様**: amount は DECIMAL(10,2) NOT NULL
- **実装**: migrations/0042 では amount NUMERIC NULL
- **推奨対応**: 仕様 or 実装のどちらに合わせるか判断（仕様変更なら 12_change_request 経由）

（全 ⚠️ について同様）

## 逆 drift（仕様にないが実装にあるもの）

### R-01: src/app/api/internal/debug/route.ts
- 仕様にない API が実装されている
- デバッグ用なら docs/03_技術設計/05_開発ガイドライン.md に開発専用とみなす旨を明記、本番では disable
- 機能なら仕様化（12_change_request 推奨）

## ステータス更新サマリー（ユーザー承認後に適用）

| FR-ID | 旧 status | 新 status | 根拠 |
| FR-01 | designed | implemented | src/features/auth/actions/signup.ts:1 に @implements |
| FR-12 | implemented | designed | 実装ファイルが見つからない |

| AC-ID | 旧 status | 新 status |
| AC-01-01 | pending | implemented |
| AC-01-03 | pending | implemented |

## 次の Sprint への申し送り
- D-01〜D-02 は次 Sprint で必ず解消
- W-01 は仕様変更とみなし `/要件定義/12_change_request` を起動推奨
- 逆 drift R-01 は仕様化方針を決定

---
生成: Phase 4 整合性チェック / Sprint {N} / {YYYY-MM-DD}
```

### Step 5: ステータス更新（User が承認した場合のみ）

承認されたら:
1. 各 `features/FR-XX.md` の frontmatter `status:` を更新
2. `02_外部設計/_index.yml` の `ac_test_mapping[].status` を更新
3. **コードは絶対に書き換えない**

---

## ⚠️ 重要な振る舞い指針

1. **コードを勝手に修正しない**。drift があっても「修正提案」までで止める
2. **根拠を必ず添える**: 「@implements が grep でヒットなし」だけでなく、対象ファイル一覧と行番号
3. **報告書ファーストで動く**。User が報告書を見て判断 → 必要なら他コマンド（12_change_request 等）を起動
4. **誤検出が出たら検査ロジック側を疑う**: 例えば動的に解決される route や、特殊な命名規則の場合は誤検出しうる
5. **`src/types/`、`*.config.ts`、`tests/factories/` 等は `@implements` 不要として無視**（ガイドラインに沿う）

---

## 🛡️ 検査の精度を上げるためのルール（開発ガイドラインに反映済み）

### 必須タグ
- 実コード: `@implements FR-XX[, AC-XX-XX, ...]`
- テストコード: `@verifies AC-XX-XX[, AC-XX-XX, ...]`
- 該当なしの shared/utility: `@implements -`

### タグが付かない / 付けにくいもの
- 自動生成ファイル（types, schemas のうち codegen 由来）
- 設定ファイル
- マイグレーションファイル

これらは `.claude/drift-ignore` のようなファイルで除外指定してもよい（必要になったら追加）。

### 検査の限界
- ロジックの正しさはテストランナーで確認（このコマンドの守備範囲外）
- 「仕様通りに動くか」は E2E テストの責務
- このコマンドは「仕様と実装の対応関係が正しいか」だけを見る

---

## よくある質問

**Q: これを CI に組み込める？**
A: 可能。AI 呼び出しを伴うのでコストは出るが、PR 時に走らせて drift を block するワークフローは実装可能。
ただし最初は手動で Sprint 末に実行 → 価値を確認してから自動化を推奨。

**Q: 機能追加のたびに `_index.yml` を手で更新するのは負担では？**
A: 通常は Phase 1〜3 のエージェントが更新する。
Sprint 中に新機能が増えた場合は `/要件定義/12_change_request` で正式に追加すれば `_index.yml` も同時に更新される。
直接編集は緊急時のみ推奨。
