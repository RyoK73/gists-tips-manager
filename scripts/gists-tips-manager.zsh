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
  local ASSETS_JSON="${SCIRPT_DIR}/../assets/assets.json"
  local assets_tags="$(jq -r '.tags | sort | .[]' "$ASSETS_JSON")"
  local assets_lang="$(jq -r '.lang | sort | .[]' "$ASSETS_JSON")"

  print-launch-message "Let's Create Tips !"

  local filename=$(gum input --placeholder=ファイル名を入力してください)
  local title=$(gum input --placeholder=タイトルを入力してください)
  local summary=$(gum write --cursor.mode=blink --header=サマリーを入力してください)
  local tags=$(gum choose --no-limit <<<"$assets_tags")
  local lang=$(gum choose --no-limit <<<"$assets_lang")
  local fullpath="${SCIRPT_DIR}/../tips/${filename}.md"
  local created_time=$(date "+%Y/%m/%d %H:%M")

  echo \
    "---
    title: ${title}
    summary: ${summary}
    tags: ${tags}
    lang: ${lang}
    created_at: ${created_time}
    updated_at:
    status: draft
    gist_id: ""
    gist_url: ""
    ---" \
    >>"$fullpath"

  if $(gum confirm "${EDITOR}で開きますか？"); then
    $EDITOR "$fullpath"
  else
    echo "${fullpath}に作成しました"
  fi
  # gist_id
  # gist_url
}

tip-new
