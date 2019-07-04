#!/usr/bin/env bash
set -eu -o pipefail

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo "Checking for required commands";

if command -v virtualenv; then
  echo "OK virtualenv";
else
  echo "Install virtualenv";
  exit 1;
fi

if command -v nvm; then
  echo "OK nvm";
else
  echo "Install nvm";
  exit 1;
fi
