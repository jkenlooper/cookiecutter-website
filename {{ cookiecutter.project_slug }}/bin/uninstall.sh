#!/usr/bin/env bash

set -eu -o pipefail
shopt -s extglob

# Uninstall and clean up script

# /srv/{{ cookiecutter.project_slug }}/
SRVDIR=$1

# /etc/nginx/
NGINXDIR=$2

# /etc/systemd/system/
SYSTEMDDIR=$3

# /var/lib/{{ cookiecutter.project_slug }}/sqlite3/
DATABASEDIR=$4

rm -rf ${SRVDIR}root/!(.well-known|.|..)

rm -rf "${SRVDIR}frozen/"

rm -f "${NGINXDIR}sites-enabled/{{ cookiecutter.project_slug }}.${ENVIRONMENT}.conf";
rm -f "${NGINXDIR}sites-available/{{ cookiecutter.project_slug }}.${ENVIRONMENT}.conf";

rm -f "${SRVDIR}.htpasswd";

rm -f /etc/cron.d/awstats-{{ cookiecutter.project_slug }}-crontab
# Stop and start in order for the crontab to be loaded (reload not supported).
systemctl stop cron && systemctl start cron || echo "Can't reload cron service"

rm -f /etc/awstats/awstats.{{ cookiecutter.site_domain }}.conf

systemctl stop {{ cookiecutter.project_slug }}-chill
systemctl disable {{ cookiecutter.project_slug }}-chill
rm -f "${SYSTEMDDIR}{{ cookiecutter.project_slug }}-chill.service";

systemctl stop {{ cookiecutter.project_slug }}-api
systemctl disable {{ cookiecutter.project_slug }}-api
rm -f "${SYSTEMDDIR}{{ cookiecutter.project_slug }}-api.service";

# TODO: Should it remove the database file in an uninstall?
echo "Skipping removal of sqlite database file ${DATABASEDIR}db"
#rm -f "${DATABASEDIR}db"

exit
