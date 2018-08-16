#!/usr/bin/env bash

set -eu -o pipefail
shopt -s extglob

# Uninstall and clean up script



# development or production
ENVIRONMENT=$1

# /srv/llama3-weboftomorrow-com/
SRVDIR=$2

# /etc/nginx/
NGINXDIR=$3

rm -rf ${SRVDIR}root/!(.well-known|.|..)

rm -f "${NGINXDIR}sites-enabled/llama3-weboftomorrow-com.${ENVIRONMENT}.conf";
rm -f "${NGINXDIR}sites-available/llama3-weboftomorrow-com.${ENVIRONMENT}.conf";

exit



# Add crontab file in the cron directory
#ADD crontab /etc/cron.d/awstats

# Give execution rights on the cron job
#RUN chmod 0644 /etc/cron.d/awstats

# Add the conf
#COPY awstats.llama3.weboftomorrow.com.conf /etc/awstats/


