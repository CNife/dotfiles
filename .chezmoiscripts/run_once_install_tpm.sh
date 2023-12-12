#! /usr/bin/env bash
set -euo pipefail

tpmDir="$HOME/.tmux/plugins/tpm"

if [ ! -d "$tpmDir" ]; then
  echo '安装TPM'
  mkdir -p "$tpmDir"
  git clone https://github.com/tmux-plugins/tpm "$tpmDir"
else
  echo 'TPM已安装'
fi

