#!/usr/bin/env zsh

set -eo pipefail

typeset -g SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
typeset -g REPO_DIR="$(realpath "${SCRIPT_DIR}/../")"
typeset -g ASSETS_JSON="${REPO_DIR}/assets/assets.json"
typeset -g TIPS_DIR="${REPO_DIR}/tips"
typeset -g TIPS_GIST_FILTER='\[Tips\]'

function print-launch-message() {
  local title=$1 subtitle=$2
  gum style \
    --foreground="#ffffff" --border-foreground="#00b5cb" \
    --border=double --align=center \
    --width=50 --margin="1 2" --padding="2 4" \
    "$title" "$subtitle"
}

# tip_dirにある*.meta.yamlとそれ以外のコンテンツファイルをそれぞれ1つずつ特定する
function resolve-tip-files() {
  local tip_dir=$1
  local f
  for f in "${tip_dir}"/*(.N); do
    if [[ "$f" == *.meta.yaml ]]; then
      echo "meta:${f}"
    else
      echo "content:${f}"
    fi
  done
}

# gist_idが空ならgh gist createで新規作成しmeta.yamlに書き戻す、あればgh gist editで上書きする
function upload-tip() {
  local tip_dir=$1
  local meta_file content_file line

  while IFS= read -r line; do
    case "${line}" in
    meta:*) meta_file="${line#meta:}" ;;
    content:*) content_file="${line#content:}" ;;
    esac
  done < <(resolve-tip-files "${tip_dir}")

  local gist_id="$(yq -r '.gist_id' "${meta_file}")"
  local title="$(yq -r '.title' "${meta_file}")"

  if [[ -z "${gist_id}" || "${gist_id}" == "null" ]]; then
    local gist_url="$(gh gist create --public --desc "[Tips] ${title}" "${content_file}" "${meta_file}")"
    local new_gist_id="${gist_url:t}"
    yq -i -y --arg gist_id "${new_gist_id}" '.gist_id = $gist_id' "${meta_file}"
    echo "gistを作成しました: ${gist_url}"
  else
    gh gist edit "${gist_id}" --filename "$(basename "${content_file}")" "${content_file}"
    gh gist edit "${gist_id}" --filename "$(basename "${meta_file}")" "${meta_file}"
    echo "gist(${gist_id})を更新しました"
  fi
}

# 補助関数(tip-editとは別役割)
# $EDITORでコンテンツファイルを開き、正常終了した場合のみアップロード確認する
# （$EDITORが異常終了した場合はset -eによりここで処理が止まり、アップロードされない）
function edit-and-maybe-upload() {
  local tip_dir=$1 content_file=$2

  if ! gum confirm "${EDITOR}で開きますか？"; then
    echo "${tip_dir} に作成しました"
    return
  fi

  "${EDITOR}" "${tip_dir}/${content_file}"

  if gum confirm "gistにアップロードしますか？"; then
    upload-tip "${tip_dir}"
  fi
}

function tip-new() {
  local assets_category="$(jq -r '.category | sort | .[]' "${ASSETS_JSON}")"
  local assets_language="$(jq -r '.language | sort | .[].name' "${ASSETS_JSON}")"

  # 対話開始
  print-launch-message "Let's Create Tips !" "Choose Tips Option !!"

  local filename="$(gum input --placeholder=ファイル名を入力してください)"
  local title="$(gum input --placeholder=タイトルを入力してください)"
  local category="$(gum filter --header=タグを選んでください --no-limit <<<"${assets_category}")"

  local language="$(gum filter --header=言語を選んでください <<<"${assets_language}")"

  local extension="$(jq -r --arg lang "${language}" '.language[] | select(.name==$lang) | .ext' "${ASSETS_JSON}")" # ファイル拡張子を特定

  local created_date="$(date "+%Y-%m-%d")"
  local category_yaml="[$(echo "${category}" | paste -sd, - | sed 's/,/, /g')]" # yaml形式の配列に変換

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

function browse-gist-list() {
  gh gist list --filter "${TIPS_GIST_FILTER}" |
    gum table --separator=$'\t' --columns="ID,Description,Files,Visibility,UpdatedAt" "$@"

}

function tip-list() {
  print-launch-message "Your Tips !" "Browse Tips List !!"

  browse-gist-list --print
}

