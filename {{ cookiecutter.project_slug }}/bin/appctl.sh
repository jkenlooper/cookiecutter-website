#!/usr/bin/env bash
set -eu -o pipefail

COMMAND=$1

# Simple convenience script to control the apps.

# Switch out nginx {{ cookiecutter.project_slug }}.conf to
# {{ cookiecutter.project_slug }}--down.conf to
# show the down page.
if test "${COMMAND}" == 'start'; then
    rm -f /etc/nginx/sites-enabled/{{ cookiecutter.project_slug }}--down.conf;
    ln -sf /etc/nginx/sites-available/{{ cookiecutter.project_slug }}.conf /etc/nginx/sites-enabled/{{ cookiecutter.project_slug }}.conf;
elif test "${COMMAND}" == 'stop'; then
    rm -f /etc/nginx/sites-enabled/{{ cookiecutter.project_slug }}.conf;
    ln -sf /etc/nginx/sites-available/{{ cookiecutter.project_slug }}--down.conf /etc/nginx/sites-enabled/{{ cookiecutter.project_slug }}--down.conf;
fi
systemctl reload nginx;

for app in {{ cookiecutter.project_slug }}-chill \
  {{ cookiecutter.project_slug }}-api;
do
  echo "";
  echo "systemctl $COMMAND $app;";
  echo "----------------------------------------";
  systemctl "$COMMAND" "$app" | cat;
done;

