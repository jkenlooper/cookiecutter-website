#!/usr/bin/env bash
set -eu -o pipefail

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo "Creating initial git repo";
git init;

echo "Installing latest nodejs LTS version"
nvm install --lts=Dubnium
nvm current > .nvmrc

echo "Installing prettier and setting git pre-commit hooks"
npm install --save-dev --save-exact prettier
npx mrm lint-staged

echo "Read the docs/development.md next.";
