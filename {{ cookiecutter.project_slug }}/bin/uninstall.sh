#!/usr/bin/env bash

set -eu -o pipefail
shopt -s extglob

# Uninstall and clean up script



# development or production
ENVIRONMENT=$1

# /srv/{{ cookiecutter.project_slug }}/
SRVDIR=$2

# /etc/nginx/
NGINXDIR=$3

rm -rf ${SRVDIR}root/!(.well-known|.|..)

rm -f "${NGINXDIR}sites-enabled/{{ cookiecutter.project_slug }}.${ENVIRONMENT}.conf";
rm -f "${NGINXDIR}sites-available/{{ cookiecutter.project_slug }}.${ENVIRONMENT}.conf";

exit
