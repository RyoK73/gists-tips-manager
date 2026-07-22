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

  local title=$(gum input --placeholder=タイトルを入力してください)
  local summary=$(gum write --cursor.mode=blink --header=サマリーを入力してください)
  local tags=$(gum choose --no-limit <<<"$assets_tags")
  local lang=$(gum choose --no-limit <<<"$assets_lang")
  # created_at
  # updated_at
  # gist_id
  # gist_url
}

tip-new
