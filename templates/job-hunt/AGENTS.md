# job-hunt — Agent Instructions (Codex / Generic)

## Project Purpose

就職活動専用ディレクトリ。企業リサーチ・書類作成・面接準備・応募管理・キャリア戦略リサーチを行う。

## Always Follow

- 書類を作成するときは必ず `self/` を参照してから書く。
- `entries/` に保存するファイルはバージョン番号を付ける（`es_v1.md` → `es_v2.md`）。
- 既存バージョンを上書きしない。改善版は新バージョンとして保存する。
- `experiences/` に追加するときは既存ファイルの最大番号 +1 で連番命名する。
- 企業リサーチではWeb検索を使い、公式情報/外部媒体/未確認情報を分ける。
- 複数部門・複数職種がある企業は、応募候補ごとに個別ディレクトリを作る。
- `tracker.md` は応募単位（企業+部門+職種+応募種別）で管理し、選考イベント履歴を残す。
- ユーザーが日付・締切・開催日程・面接日・Webテスト期限・提出期限・結果通知予定などを共有した場合は、必ず `tracker.md` と該当企業の `questions.md` / `research.md`、必要に応じて `notes/作業アーカイブ/` へ反映する。
- Google Calendarへ予定・締切・面接・授業・仕事・確認タスクを登録/更新/確認する場合は `calendar-scheduler` を使う。就活に関係する予定は、Calendarだけでなく `tracker.md` / 企業別ファイル / `notes/todos/todo.html` / 作業ログも同期する。
- 日程情報を扱うときは、既存の他社日程・締切と照合し、衝突、代替ターム、優先順位、次アクションを必ず確認してユーザーに伝える。
- 技術革新・産業変化・職種選びの上位判断は `notes/career-strategy/` に整理する。
- 業界/職種/応募方針の重要判断は `notes/decisions/` に記録する。
- フォルダ構成、Skill、Command、Agent定義を変える場合は、Codex/Claude双方の設定ファイルをそろえる。
- 継続的に使う新規ディレクトリや定番ファイルを作った場合は、同じターンで `Directory Layout` / `Key Paths` / 関連Skillの保存先ルールへ反映する。
- 会話中に自己分析・応募状況・企業情報・方針決定などが出たら、適切な既存ドキュメントへロールアップする。
- git commit はユーザーが明示的に求めたときのみ行う。

## Directory Layout

```
self/
  profile.md
  strengths.md
  pr_templates.md
  interview_questions.md
  character_episode_inventory.md
  deep_dive_questions.md
  experiences/001_経験名.md, 002_...
companies/
  <会社名>/
    research.md
    questions.md
    entries/<type>_v<N>.md
  <グループ名>/_overview.md
  <グループ名>/<部門名>/
    research.md
    questions.md
    entries/<type>_v<N>.md
    interview/prep.md
    interview/log.md
docs/
  resume.md
  portfolio.md
tracker.md
notes/
  career-strategy/README.md
  career-strategy/source-map.md
  career-strategy/initial-synthesis.md
  career-strategy/personal-hypotheses.md
  career-strategy/research-backlog.md
  decisions/DECISION_LOG.md
  decisions/YYYY-MM-DD_<topic>.md
  todos/README.md
  todos/todo.html
  selection-prep/web-tests/YYYY-MM-DD_<company>_<topic>.md
  selection-prep/interviews/YYYY-MM-DD_<company>_<topic>.md
  その他/<freeform-note>.md
  作業アーカイブ/YYYY-MM-DD_作業ログ.md
```


## Conversation Rollup Standard

会話中に、既存ドキュメントへ反映した方がよい新情報・決定・進捗が出た場合は、ユーザーが明示的に「記録して」と言わなくても、文脈上確からしい範囲で適切なファイルへロールアップする。

ロールアップ先の原則:

| 会話で得た情報 | 更新先 | 更新方法 |
|---|---|---|
| プロフィール、価値観、希望条件、避けたい条件 | `self/profile.md`, `self/strengths.md` | 既存内容と矛盾しない形で追記・整理。矛盾がある場合は日付つきで新見解として残す。 |
| 経験、実績、数値実績 | `self/experiences/` | 新規経験は最大番号+1で追加。既存経験の補足は該当ファイルへ追記。 |
| キャラクター、人柄、面白いエピソードの棚卸し | `self/character_episode_inventory.md` | ES・面接で使えそうな素材として追記。企業向け文章にする前の粗い素材も残してよい。 |
| 深掘り質問、未確認事項、後でヒアリングすべき内容 | `self/deep_dive_questions.md` | 優先度や用途が分かる形で追記。回答が得られたら `self/` や `companies/` の該当ファイルへ反映する。 |
| 自己PR、ガクチカ、志望軸に使える表現 | `self/pr_templates.md` | 素材として追記。完成版として固定しすぎない。 |
| 応募、ES提出、Webテスト、面接、結果、辞退 | `tracker.md` | 応募単位で `選考パイプライン` / `選考イベント履歴` / `完了` を更新。 |
| 締切、開催日程、希望ターム、面接日、Webテスト期限、結果通知予定 | `tracker.md`, `companies/<path>/questions.md`, `companies/<path>/research.md`, `notes/作業アーカイブ/` | 絶対日付で記録し、応募単位の次アクション/期限とイベント履歴に反映。既存日程との衝突、代替ターム、希望順位、次アクションも確認して残す。 |
| 面接予定、面接後メモ、聞かれた質問 | `companies/<path>/interview/`, `questions.md`, `tracker.md` | 面接準備/ログとイベント履歴を両方更新。 |
| 企業・部門・職種に関する新情報 | `companies/<path>/research.md`, `questions.md`, `_overview.md` | 情報確度と日付、可能ならURLを付けて追記。 |
| 業界・職種・技術変化の仮説 | `notes/career-strategy/` | 情報源は `source-map.md`、解釈は `initial-synthesis.md`、個人戦略は `personal-hypotheses.md`。 |
| 方針決定、優先順位変更、応募する/しない判断 | `notes/decisions/DECISION_LOG.md` + 個別判断ファイル | 背景、選択肢、決定、理由、見直し条件を残す。 |
| 直近Todo、出すべき未提出応募、受験・予約・確認タスク | `notes/todos/todo.html` | 作戦ボードとして更新。履歴性のある事実は必ず `tracker.md` と企業別ファイルにも反映する。 |
| Webテスト、ケース、GD、面接などの攻略ノート・対策メモ | `notes/selection-prep/` | Webテストは `web-tests/`、面接は `interviews/` など選考種別ごとに整理。企業固有ならファイル名に企業名を入れる。 |
| 作業の流れ、まとまった実施内容 | `notes/作業アーカイブ/YYYY-MM-DD_作業ログ.md` | 原則1日1ファイルに追記し、後から再開できる粒度でロールアップする。 |
| 汎用メモ、運用設計、企業や自己分析に直接属さない調査 | `notes/その他/` | 後で移動・昇格できるよう、出典・作成日・用途を残す。 |

運用ルール:

- 既存情報を上書きで消さない。古い情報と新情報が食い違う場合は、日付と文脈を付けて併記する。
- 日付情報は相対表現だけで残さない。ユーザーが「今日」「明日」「来週」「この締切」などで共有した場合も、現在日付を基準に `YYYY-MM-DD`、必要なら時刻・タイムゾーン付きで記録する。
- 日程が未確定・候補段階でも、候補として記録する。確定情報、ユーザー共有情報、推測を分ける。
- 日程を受け取ったら、既存の `tracker.md`、企業別 `questions.md` / `research.md`、作業ログ内の他社日程を横断確認し、重複・近接締切・予約変更可否・辞退/代替可能性を確認する。完全に確定できない場合も「要確認」として残す。
- 複数タームから選べる場合は、単に最短日程を選ばず、他社日程との衝突の少なさ、志望度、早期選考接続、変更可否を踏まえて推奨順位を出す。
- 推測は断定しない。本人発言、公式情報、外部情報、推測を分ける。
- 個人情報やセンシティブな情報は、必要最小限にし、公開前提のファイルに過度に詳しく書かない。
- 会話の本題を止めない範囲で更新する。大規模な整理が必要な場合は、まず最小限のログを残し、必要なら作業アーカイブに TODO を置く。
- 新しい定番ファイルやディレクトリを作った場合は、設定ファイルがその保存先を追えているか確認し、不足があれば `~/develop/devenv/templates/job-hunt/` 側から更新して同期する。
- ロールアップした場合は、最終報告で更新ファイルを簡潔に伝える。

## Company Research Standard

- 単体企業でも採用コースが複数ある場合は、必要に応じて `<会社名>/<職種名>/` に分ける。
- グループ共通情報は `_overview.md` に置く。
- `_overview.md` には部門比較、フィット評価、おすすめ順位、インターン/選考の全体像、追加調査候補を入れる。
- `research.md` には部門/職種の役割、採用情報、AI・IT・業務改善との接点、自分とのフィット、未確認事項、主要ソースを入れる。
- `questions.md` にはES設問、面接質問、逆質問候補を入れる。

## Tracker Standard

`tracker.md` は以下の粒度で扱う。

- 応募単位: 企業 + 部門 + 職種 + 応募種別
- 進行中: `## 選考パイプライン`
- すべての出来事: `## 選考イベント履歴`
- 終了案件: `## 完了`
- 候補企業: 優先度別の未応募リスト

標準ステージ: 情報収集、応募準備、ES作成中、ES提出済み、Webテスト/適性検査、書類選考中、GD/グループワーク、ケース/筆記、一次面接、二次面接、最終面接、インターン参加、早期選考案内、内定、不合格、辞退。


## Career Strategy Research Standard

`notes/career-strategy/` は、技術革新・産業変化・職種価値・個人戦略を扱う。

- 国内外を問わず幅広い情報源を見る: 国際機関、官公庁、シンクタンク、コンサル、企業レポート、学術、労働市場データ、反対意見。
- 1つの情報源だけで結論を出さない。最低でも `公式/公的`, `民間調査`, `労働市場データ`, `反対意見/リスク指摘` を分ける。
- `source-map.md` には情報源、主張、就活への示唆、確度、URLを入れる。
- `initial-synthesis.md` には事実の要約ではなく、自分の言葉でかみ砕いた仮説を書く。
- `personal-hypotheses.md` には `self/` と照らした業界/職種/スキル仮説を書く。
- 重要な判断をしたら `notes/decisions/DECISION_LOG.md` と個別判断ファイルに残す。
- 事実、予測、解釈、自分への示唆を混ぜない。日付は絶対日付で書く。

## Skills Location

`.agents/skills/<name>/SKILL.md`

## Skills Available

- `self-analysis` — 自己分析の棚卸し → `self/` に保存
- `company-research` — 企業/部門/職種リサーチ → `companies/<path>/research.md` に保存
- `career-strategy` — 技術革新・産業変化・職種選びリサーチ → `notes/career-strategy/` と `notes/decisions/` に保存
- `doc-writer` — 設問への回答・書類作成 → `entries/` にバージョン付きで保存
- `interview-prep` — 面接想定Q&A生成・面接後メモ
- `job-tracker` — 応募状況・選考履歴の更新（tracker.md + Notion MCP）
- `calendar-scheduler` — Google Calendar登録・更新・確認。就活では Calendar + tracker.md + 企業別ファイル + todo.html + 作業ログを同期。大学・仕事・私用の予定にも使用可

## Notion MCP

Notion MCP が有効な場合、`job-tracker` は `tracker.md` と Notion DB を両方更新する。MCP が無効な場合は `tracker.md` のみ更新する。

## Tooling

- Web検索は `company-research` で積極的に使用する。
- シェルコマンドの実行は最小限にする。
- 依存関係のインストールが必要な場合は先に確認する。


## Agent Configuration Maintenance Standard

フォルダ構成、運用ルール、Skill、Slash Command、Codex agent、Claude agent に関する変更指示が出た場合は、Codex と Claude Code の双方で同じ運用ができるように設定ファイルを更新する。

原則:

- 設定の正本は `~/develop/devenv/templates/job-hunt/`。まず devenv 側を編集し、`scripts/sync.sh /home/yukawasaki/develop/job-hunt --dry-run` で確認してから同期する。
- `AGENTS.md` と `CLAUDE.md` の片方だけを更新しない。共通ルールは両方へ反映する。
- Skill を追加/変更したら、必要に応じて `.agents/skills/<name>/SKILL.md`、`.codex/agents/<name>.toml`、`.claude/agents/<name>.md` をそろえる。
- Slash Command を追加/変更したら、`.claude/commands/<name>.md` と、Codex/Generic 側で代替できる手順を `AGENTS.md` に書く。
- ディレクトリ構成を変えたら、`Directory Layout`、`Key Paths`、関連Skillの保存先ルールを更新する。
- 更新後は `git diff --check` を実行し、同期後の job-hunt 側にも反映されたことを確認する。
- git commit はユーザーが明示的に求めたときのみ行う。

## Skill・設定の修正方法

このプロジェクトの設定ファイルは **devenv** (`~/develop/devenv/`) で一元管理されている。

| 修正内容 | 編集先 |
|---|---|
| Skill の動作 | `templates/job-hunt/.agents/skills/<name>/SKILL.md` |
| Codex の動作・ルール | `templates/job-hunt/AGENTS.md` |
| Claude の動作・ルール | `templates/job-hunt/CLAUDE.md` |
| Codex agent | `templates/job-hunt/.codex/agents/<name>.toml` |
| Claude agent | `templates/job-hunt/.claude/agents/<name>.md` |
| Slash Command | `templates/job-hunt/.claude/commands/<name>.md` |

編集後: `scripts/sync.sh /home/yukawasaki/develop/job-hunt --dry-run` で確認 → `--dry-run` を外して反映。
