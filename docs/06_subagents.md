# サブエージェント仕様リファレンス

Claude Code と Codex CLI 両方のサブエージェント機能をまとめたリファレンス。

---

## Claude Code — カスタムエージェント

### 定義ファイルの場所

| スコープ | パス |
|---------|------|
| グローバル（全プロジェクト） | `~/.claude/agents/<name>.md` |
| プロジェクト固有 | `.claude/agents/<name>.md` |

### ファイル形式

```markdown
---
name: agent-name                         # 必須・英数字ハイフン
description: いつ使うかの説明（重要）    # 必須・Claude がここを見て自動選択する
model: claude-haiku-4-5-20251001         # 省略可。省略時は親セッションと同モデル
tools:                                   # 許可するツール（省略時はデフォルト全許可）
  - WebSearch
  - WebFetch
  - Read
  - Write
disallowedTools:                         # 禁止するツール
  - Bash
permissionMode: default                  # default | acceptEdits | bypassPermissions
---

# エージェントの指示（Markdown）

ここにエージェントの役割・手順・出力形式を書く。
```

### 主要フィールド

| フィールド | 説明 |
|-----------|------|
| `name` | 識別子。`Agent(subagent_type: "name")` で呼び出し |
| `description` | **最重要**。Claude が自動委譲するかどうかをここで判断 |
| `model` | モデル指定。軽量タスクは Haiku、高品質は Sonnet |
| `tools` | 明示する場合はここで絞り込む |
| `disallowedTools` | 禁止ツール |
| `permissionMode` | `bypassPermissions` で確認なし自動実行 |

### 組み込み subagent_type 一覧

| 型 | 用途 | ツール制限 |
|----|------|-----------|
| `claude` | 汎用（デフォルト） | 全ツール |
| `Explore` | 読み取り専用の高速検索 | 読み取り系のみ |
| `Plan` | 実装計画の立案 | 読み取り系のみ |
| `general-purpose` | 複雑なマルチステップ | 全ツール |
| `claude-code-guide` | Claude Code/API の質問調査 | 調査系 |

### Agent ツールの呼び出し方

```
Agent(
  description: "何をするか3〜5語",
  subagent_type: "エージェント名",   # 省略時は general-purpose
  prompt: "タスクの詳細指示",
  model: "claude-haiku-4-5-20251001", # オプション（オーバーライド）
  run_in_background: true,            # バックグラウンド実行
  isolation: "worktree"               # git worktree で隔離
)
```

### isolation: "worktree" とは

サブエージェントを独立した git worktree（ブランチのコピー）で実行する。
- 変更がメインブランチを汚染しない
- 変更なしで完了 → worktree は自動削除
- 変更ありで完了 → worktree のパスとブランチ名が返ってくる
- コードレビュー・実験的な変更に有効

### 複数エージェントの並列実行

同一メッセージで複数の `Agent` ツール呼び出しを送ると並列実行される。

```
# 並列で3社を調査する例
Agent(..., prompt: "アクセンチュアを調査して")
Agent(..., prompt: "IBMを調査して")
Agent(..., prompt: "アビームを調査して")
```

### 結果の受け渡し

- サブエージェントは独立したコンテキストウィンドウで動作
- 完了後、サマリーを1メッセージとして親セッションに返す
- `SendMessage(to: "agent-id")` で継続中のエージェントに追加指示を送れる
- ファイルへの書き込みが主な情報共有手段（特に `run_in_background: true` 時）

---

## Codex CLI — サブエージェント

### 定義ファイルの場所

| スコープ | パス |
|---------|------|
| グローバル | `~/.codex/agents/<name>.toml` |
| プロジェクト固有 | `.codex/agents/<name>.toml` |

### ファイル形式

```toml
name = "agent-name"
description = "エージェントの説明"
model = "gpt-4.1-mini"   # 省略可

[instructions]
content = """
エージェントの役割・手順をここに書く（マルチライン文字列）。
"""

# MCP サーバーの設定（オプション）
[[mcp_servers]]
name = "notion"
command = "npx"
args = ["-y", "@notion/mcp-server"]
```

### 並列実行の設定（`.codex/config.toml`）

```toml
[agents]
max_threads = 6      # 同時実行エージェント数（デフォルト 6）
max_depth = 1        # サブエージェントのネスト深度（デフォルト 1）
job_max_runtime_seconds = 300  # タイムアウト
```

### 組み込みロール

| ロール | 特性 |
|--------|------|
| `default` | 汎用 |
| `worker` | 実行・書き込み重視 |
| `explorer` | 読み取り・調査重視 |

---

## Claude Code vs Codex 比較

| 項目 | Claude Code | Codex |
|------|-------------|-------|
| 定義形式 | Markdown + YAML frontmatter | TOML |
| スコープ | global / project | global / project |
| ツール制御 | `tools` / `disallowedTools` フィールド | sandbox 設定 |
| 並列実行 | 同一メッセージで複数 Agent 呼び出し | `max_threads` で上限設定 |
| 結果返却 | 1メッセージ + ファイル共有 | スレッド統合 |
| 隔離実行 | `isolation: "worktree"` | sandbox（サンドボックス設定） |
| モデル指定 | エージェントごと・呼び出し時オーバーライド可 | エージェントごと |

---

## 就活ワークフローでの活用パターン

```
# 複数社を並列リサーチ（Claude Code）
Agent(subagent_type: "company-research", prompt: "アクセンチュアのテクノロジーコンサルタント職を調査")
Agent(subagent_type: "company-research", prompt: "IBMコンサルティングのITコンサルタント職を調査")
↓
両方の research.md が作成されたら doc-writer で書類作成
```

---

## 参照

- Claude Code agents: `.claude/agents/` ディレクトリに SKILL.md と同じ命名規則で配置
- 就活用エージェント定義: `templates/job-hunt/.claude/agents/` と `templates/job-hunt/.codex/agents/`
