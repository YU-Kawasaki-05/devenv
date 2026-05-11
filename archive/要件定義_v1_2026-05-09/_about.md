# 要件定義 v1 (2026-05-09 archived)

## 元の場所
`~/.claude/commands/要件定義/`

## 置き換え理由
v2 への全面再設計。v1 では以下の弱点があった:
- 仕様⇄コードの drift 検出機構なし
- 仕様変更時の影響波及ワークフローなし
- README / ONBOARDING / CONTRIBUTING の生成が抜け
- 図表が Mermaid のみ（drawio などチーム共有しやすい形式なし）
- per-FR ファイル分割なし → 機能変更時の diff が爆発
- 機械可読インデックス（_index.yml）なし → AI コンテキスト効率が悪い
- テスト戦略・運用設計（observability）・ローンチ計画の Phase が抜け

## v2 で対応した変更
- 元の 3 Phase（要件定義・外部設計・技術設計）を維持しつつ各内容を強化
- Phase 4: 仕様⇄コード整合性チェック（drift 検出）を新設
- ユーティリティコマンドを追加: README 生成・drawio 生成・変更リクエスト
- 出力形式を per-FR ファイル + `_index.yml` 併走に変更

## 参照したいとき
ここの 3 ファイルを直接読む。Claude Code の slash command としては登録していない。
