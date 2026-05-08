# Project Skills (.claude/skills)

Claude Code および GitHub Copilot (Agent Skills) 用プロジェクトスキル。

GitHub Copilot は `.claude/skills/`、`.agents/skills/`、`.github/skills/` をすべてサポートする。
このディレクトリがすべてのツールの正規の場所として機能する。

## Skill の追加方法

```bash
mkdir -p .claude/skills/<skill-name>
# SKILL.md を作成 (frontmatter: name, description 必須)
```

## Cross-tool 対応

Copilot は `.claude/skills/` を読む。
Codex 向けには `.agents/skills/` にシンボリックリンクを作成する:

```bash
cd .agents/skills && ln -s ../../.claude/skills/<skill-name> <skill-name>
```
