#!/usr/bin/env zsh

set -eo pipefail

function print-launch-message() {
  local title=$1 subtitle=$2
  gum style \
    --foreground="#ffffff" --border-foreground="#00b5cb" \
    --border=double --align=center \
    --width=50 --margin="1 2" --padding="2 4" \
    "$title" "$subtitle"
}

function tip-new() {
  # ファイルパスの設定
  local SCIRPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
  local REPO_DIR="$(realpath "${SCIRPT_DIR}/../")"

  local ASSETS_JSON="${REPO_DIR}/assets/assets.json"
  local TIPS_DIR="${REPO_DIR}/tips"

  local assets_category="$(jq -r '.category | sort | .[]' "${ASSETS_JSON}")"
  local assets_language="$(jq -r '.language | sort | .[].name' "${ASSETS_JSON}")"

  # 対話開始
  print-launch-message "Let's Create Tips !" "Choose Tips Option !!"

  local filename="$(gum input --placeholder=ファイル名を入力してください)
"
  local title="$(gum input --placeholder=タイトルを入力してください)"
  local category="$(gum filter --header=タグを選んでください --no-limit <<<"${assets_category}")"

  local language="$(gum filter --header=言語を選んでください --limit 1 <<<"${assets_language}")"
  local file-ext="$(jq -r '.language[] | select(.name=="${assets_language}") | .ext')"

  local created_date="$(date "+%Y-%m-%d")"
  local category_yaml="[$(echo "${category}" | paste -sd, - | sed 's/,/, /g')]"
  
  local fullpath="${save_dir}/${created_date}-${filename}.yaml"

  touch ${fullpath}
  echo <<-EOF >"${save_dir}/${created_date}-${filename}.meta.yaml"
    ---
    title: ${title}
    category: ${category_yaml}
    created_at: ${created_date}
    ---
EOF

  if $(gum confirm "${EDITOR}で開きますか？"); then
    $EDITOR "${fullpath}"
  else
    echo "$(dirname "${fullpath}")に作成しました"
  fi
}

tip-new
