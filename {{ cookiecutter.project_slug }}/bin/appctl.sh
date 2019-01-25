#!/usr/bin/env bash
set -eu -o pipefail

COMMAND=$1

# Simple convenience script to control the apps.

for app in {{ cookiecutter.project_slug }}-chill \
  {{ cookiecutter.project_slug }}-api;
do
  echo "";
  echo "systemctl $COMMAND $app;";
  echo "----------------------------------------";
  systemctl "$COMMAND" "$app" | cat;
done;

