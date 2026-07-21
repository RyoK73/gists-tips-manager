## gist-tips-manager

CLIでGithub Gist作成を簡略化し、開発中の気づいたこと・メモなどを気軽にTipsとして登録することができる

## このリポジトリで得られるもの

- [ ] TipsとしてGithub Gistを作成するためのCLIコマンド
- [ ] Tipsの説明・背景などをGistに書き込むための対話式UI
- [ ] Github Gistに作成されたTipsをブログ・サービスなどで利用可能にするGithub APIを通したパース実装

## 動作環境

### OS

- [ ] Arch Linux

### シェル

- [ ] zsh

## 機能

### 構成

```bash
.
├── LICENSE
├── README.md
├── docs
├── scripts
└── tips
    ├── draft
    └── uploaded
```

### 依存ライブラリ

- [gum](https://github.com/charmbracelet/gum.git)

### フロントマター

```md
---
title:""
summary:""
tags:[]
lang:""
created_at:""
updated_at:""
status:""
gist_id:""
gist_url:""
---
```

### 関数

- [ ] tip-new: フロントマターを対話入力 -> $EDITORで本文執筆
- [ ] tip-list: tips一覧をstatusつきで表示
- [ ] tip-update: 公開済みgistの内容を`gh gist edit`で更新

## 使い方

1. `gum`のインストール
   `pacman -S gum`
