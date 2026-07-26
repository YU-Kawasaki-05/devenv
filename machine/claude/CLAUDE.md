# Personal Claude Instructions

## Communication
- 返答は簡潔に。冗長な説明より具体的なコードや事実を優先する
- 不明点があれば先に確認する。推測で進まない
- コード変更後に「〜を変更しました」といった末尾サマリーは不要

## Code Style
- コメントは「なぜ」が自明でない場合のみ書く
- 必要以上の抽象化・リファクタリングを加えない
- エラーハンドリングはシステム境界（ユーザー入力・外部API）のみ
- 未使用コードは残さず削除する

## Workflow
- 可逆な変更（ファイル編集・テスト実行）は確認なしで進める
- 破壊的・不可逆な操作（force push・ファイル削除・外部送信）は事前確認する
- git コミットはユーザーが明示的に求めたときのみ行う
- セキュリティに関わる変更（auth・crypto・外部通信）は必ず指摘する

## Skills
個人用 Skills は `~/.claude/skills/` に格納。
呼び出し: `/skill-name` または依頼内容が description に合致すれば自動適用。

利用可能な Skills:
- `/pr-review` — PR・差分のレビュー
- `/debug-investigator` — 障害・テスト失敗の調査
- `/test-specialist` — テスト追加・カバレッジ確認
- `/dependency-upgrade` — ライブラリ・フレームワークの更新
- `/release-manager` — リリース準備・changelog 作成
- `/adr-writer` — 設計判断の記録（ADR）
- `/a11y-review` — アクセシビリティレビュー
- `/study-guide` — HTML学習教材の生成（アルゴリズム・CS・フレームワーク等、あらゆるトピック）
