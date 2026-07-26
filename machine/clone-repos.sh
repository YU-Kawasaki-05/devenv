#!/usr/bin/env bash
# 全リポジトリを新マシンに clone する (冪等: 既存ディレクトリはスキップ)
# 前提: SSH 鍵設定済み (setup-mac.sh + MIGRATION.md の手順完了後)
set -uo pipefail

DEVELOP="$HOME/develop"
mkdir -p "$DEVELOP"

clone() {
  local url="$1" dst="$2"
  if [ -d "$dst/.git" ]; then
    echo "skip (exists): $dst"
    return 0
  fi
  echo "clone: $url -> $dst"
  git clone "$url" "$dst" || echo "!! FAILED: $url"
}

# --- 個人 (YU-Kawasaki-05 / 鍵: id_ed25519) ---
clone git@github.com:YU-Kawasaki-05/devenv.git          "$DEVELOP/devenv"
clone git@github.com:YU-Kawasaki-05/Ardors-website.git  "$DEVELOP/Ardors-website"
clone git@github.com:YU-Kawasaki-05/job-hunt.git        "$DEVELOP/job-hunt"
clone git@github.com:YU-Kawasaki-05/jovin.git           "$DEVELOP/jovin"
clone git@github.com:YU-Kawasaki-05/lifeapp.git         "$DEVELOP/lifeapp"
clone git@github.com:YU-Kawasaki-05/juku-ai-slack.git   "$DEVELOP/marujuku-slack"
clone git@github.com:YU-Kawasaki-05/premake.git         "$DEVELOP/premake"
clone git@github.com:YU-Kawasaki-05/schedule_app.git    "$DEVELOP/schedule_app"
clone git@github.com:YU-Kawasaki-05/wit.git             "$DEVELOP/wit"
clone git@github.com:YU-Kawasaki-05/atcoder.git         "$DEVELOP/atcoder"
clone git@github.com:YU-Kawasaki-05/slide-gen.git       "$DEVELOP/slide-gen"
clone git@github.com:YU-Kawasaki-05/slide-web.git       "$DEVELOP/slide-web"
clone git@github.com:YU-Kawasaki-05/slide-web-new.git   "$DEVELOP/slide-web-new"
clone git@github.com:YU-Kawasaki-05/thinking-space.git  "$DEVELOP/thinking-space"
clone git@github.com:YU-Kawasaki-05/univ.git            "$DEVELOP/univ"
clone git@github.com:YU-Kawasaki-05/marubo_ai.git       "$HOME/marubo_ai"

# --- 仕事 (FourYou / 鍵: id_ed25519_fouryou, SSH エイリアス github.com-fouryou) ---
clone git@github.com-fouryou:FourYou-inc/evs-AI-basedTestSpecificationCreation.git \
      "$DEVELOP/evs-AI-basedTestSpecificationCreation"
mkdir -p "$DEVELOP/rio"
clone git@github.com-fouryou:FourYou-inc/rio-corp-systems.git "$DEVELOP/rio/rio-corp-systems"

echo ""
echo "完了。rio 直下の作業ファイル (git 管理外・機密) は tar で別途転送すること (MIGRATION.md 参照)。"
