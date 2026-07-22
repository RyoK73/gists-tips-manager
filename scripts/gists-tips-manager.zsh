#!/usr/bin/env zsh

set -eo pipefail

function tip-new() {
  assets_status=(draft uploaded)

  SCIRPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
  ASSETS_JSON="${SCIRPT_DIR}/../assets/assets.json"
  assets_tags="$(jq -r '.tags | sort | .[]' "$ASSETS_JSON")"
  assets_lang="$(jq -r '.lang | sort | .[]' "$ASSETS_JSON")"

  title=$(gum input --placeholder=タイトルを入力してください)
  summary=$(gum write --cursor.mode=blink --header=サマリーを入力してください)
  tags=$(gum choose --no-limit <<<"$assets_tags")
  lang=$(gum choose --no-limit <<<"$assets_lang")
  # created_at
  # updated_at
  # gist_id
  # gist_url
}

tip-new
