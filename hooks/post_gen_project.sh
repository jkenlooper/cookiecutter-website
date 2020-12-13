#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

[ ! -z $NVM_DIR ] || (
  [ -e $HOME/.nvm ] && NVM_DIR="$HOME/.nvm"
  [ -e $HOME/.config/nvm ] && NVM_DIR="$HOME/.config/nvm"
  [ ! -z $NVM_DIR ] || (
    echo "Error: no $HOME/.nvm or $HOME/.config/nvm found." \
      && exit 1
  )
  export NVM_DIR=$NVM_DIR
)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo "Creating initial git repo";
git init;

echo "Installing latest nodejs LTS version"
nvm install --lts=Erbium
nvm current > .nvmrc

echo "Installing prettier, eslint, stylelint, and setting git pre-commit hooks"
npm install --save-dev --save-exact prettier
npm install --save-dev eslint-plugin-prettier eslint eslint-config-prettier
npm install --save-dev stylelint stylelint-prettier stylelint-config-prettier
npx mrm lint-staged

echo "Running prettier on all initial files."
npm run prettier -- --write \
  *.md \
  */*.md \
  design-tokens/ \
  docs/ \
  root/ \
  src/ \
  webpack.config.js

echo "Creating initial git commit";
nvm use;
git add .;
# The initial commit needs the --no-verify.
git commit --no-verify -m "Add generated files from cookiecutter-website";

echo "Read the docs/development.md next.";
