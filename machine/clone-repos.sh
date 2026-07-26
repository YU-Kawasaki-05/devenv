#!/usr/bin/env bash
# 全リポジトリを新マシンに clone する (冪等: 既存ディレクトリはスキップ)
# 前提: SSH 鍵設定済み (setup-mac.sh + MIGRATION.md の手順完了後)
#
# 第3引数のブランチは「WSL からの移行時点で作業中だったブランチ」。
# 新しく作業を始める場合は無視してよい。
set -uo pipefail

DEVELOP="$HOME/develop"
mkdir -p "$DEVELOP"

clone() {
  local url="$1" dst="$2" branch="${3:-}"
  if [ -d "$dst/.git" ]; then
    echo "skip (exists): $dst"
    return 0
  fi
  echo "clone: $(basename "$dst")"
  if ! git clone -q "$url" "$dst"; then
    echo "!! FAILED: $url"
    return 1
  fi
  if [ -n "$branch" ]; then
    git -C "$dst" checkout -q "$branch" 2>/dev/null || echo "   (branch $branch なし — default のまま)"
  fi
}

echo "=== 個人リポジトリ (鍵: id_ed25519) ==="
clone git@github.com:YU-Kawasaki-05/devenv.git          "$DEVELOP/devenv"          main
clone git@github.com:YU-Kawasaki-05/Ardors-website.git  "$DEVELOP/Ardors-website"  feature/ard-34-content-update
clone git@github.com:YU-Kawasaki-05/job-hunt.git        "$DEVELOP/job-hunt"        main
clone git@github.com:YU-Kawasaki-05/jovin.git           "$DEVELOP/jovin"           main
clone git@github.com:YU-Kawasaki-05/lifeapp.git         "$DEVELOP/lifeapp"         feature/codex-env-and-branch-policy
clone git@github.com:YU-Kawasaki-05/juku-ai-slack.git   "$DEVELOP/marujuku-slack"  develop
clone git@github.com:YU-Kawasaki-05/premake.git         "$DEVELOP/premake"         feat/nominee-linking-and-polish
clone git@github.com:YU-Kawasaki-05/schedule_app.git    "$DEVELOP/schedule_app"    feature/schedule-app-mvp
clone git@github.com:YU-Kawasaki-05/wit.git             "$DEVELOP/wit"             main
clone git@github.com:YU-Kawasaki-05/marubo_ai.git       "$HOME/marubo_ai"          fix/deps-next15

echo "=== スライド・学習ツール (public) ==="
clone git@github.com:YU-Kawasaki-05/atcoder.git         "$DEVELOP/atcoder"         main
clone git@github.com:YU-Kawasaki-05/slide-gen.git       "$DEVELOP/slide-gen"       main
clone git@github.com:YU-Kawasaki-05/slide-web.git       "$DEVELOP/slide-web"       main
clone git@github.com:YU-Kawasaki-05/slide-web-new.git   "$DEVELOP/slide-web-new"   main

echo "=== 事業情報を含む private repo ==="
# slide-web-new/decks は親 repo が gitignore している入れ子 repo (事業情報を含むため分離)
clone git@github.com:YU-Kawasaki-05/slide-web-new-decks.git "$DEVELOP/slide-web-new/decks" main
clone git@github.com:YU-Kawasaki-05/thinking-space.git      "$DEVELOP/thinking-space"      main

echo "=== 仕事 (FourYou / 鍵: id_ed25519_fouryou) ==="
clone git@github.com-fouryou:FourYou-inc/evs-AI-basedTestSpecificationCreation.git \
      "$DEVELOP/evs-AI-basedTestSpecificationCreation" \
      generate-uat-specs-and-testdata-eval15-20260224-separate
mkdir -p "$DEVELOP/rio"
clone git@github.com-fouryou:FourYou-inc/rio-corp-systems.git \
      "$DEVELOP/rio/rio-corp-systems" \
      feature/138-tokuyaku-file-condition-input

cat <<'EOF'

=== clone 完了 ===
GitHub 経由で移行できないもの (MIGRATION.md 参照して tar 転送):
  - ~/develop/univ/          大学資料 3.2GB (271MB の pptx があり GitHub の 100MB 制限を超える)
  - ~/develop/rio/ 直下       クライアント案件の作業ファイル (機密・git 管理外)
  - ~/NoovaInc/              移行対象外
  - 各プロジェクトの .env*    API キー類
EOF
