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
  local assets_status=(draft uploaded)
  local SCIRPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
  local ASSETS_JSON="$(cd "${SCIRPT_DIR}/../assets" && pwd)/assets.json"
  local assets_category="$(jq -r '.category | sort | .[]' "${ASSETS_JSON}")"
  local assets_lang="$(jq -r '.lang | sort | .[]' "${ASSETS_JSON}")"

  print-launch-message "Let's Create Tips !" "Choose Tips Option !!"

  local filename="$(gum input --placeholder=ファイル名を入力してください)
"
  local title="$(gum input --placeholder=タイトルを入力してください)"
  local category="$(gum choose --header=タグを選んでください --no-limit <<<"${assets_category}")"
  local category_yaml="[$(echo "${category}" | paste -sd, - | sed 's/,/, /g')]"
  local lang="$(gum choose --header=言語を選んでください --no-limit <<<"${assets_lang}")"
  local created_date="$(date "+%Y-%m-%d")"
  local save_dir="$(cd "${SCIRPT_DIR}/../tips" && pwq)"

  echo \
    "---
    title: ${title}
    category: ${category_yaml}
    created_at: ${created_date}
    ---
EOF

  if $(gum confirm "${EDITOR}で開きますか？"); then
    $EDITOR "$fullpath"
  else
    echo "${fullpath}に作成しました"
  fi
  # gist_id
  # gist_url
}

tip-new
