#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

[ -e $HOME/.nvm ] && NVM_DIR="$HOME/.nvm"
[ -e $HOME/.config/nvm ] && NVM_DIR="$HOME/.config/nvm"
[ ! -z $NVM_DIR ] || (
    echo "Error: no $HOME/.nvm or $HOME/.config/nvm found."
)
export NVM_DIR
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo "Checking for required commands";

if command -v nvm; then
  echo "OK nvm";
else
  echo "Error: Missing nvm. Install nvm to continue.";
  exit 1;
fi
