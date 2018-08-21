#!/usr/bin/env bash
set -eu -o pipefail

# development or production
#ENVIRONMENT=$1

# /srv/llama3-weboftomorrow-com/
SRVDIR=$1

# /etc/nginx/
NGINXDIR=$2


mkdir -p "${SRVDIR}root/";
#chown -R dev:dev "${SRVDIR}root/";
rsync --archive \
  --inplace \
  --delete \
  --exclude=.well-known \
  --itemize-changes \
  root/ "${SRVDIR}root/";
echo "rsynced files in root/ to ${SRVDIR}root/";

# Run rsync checksum on nginx default.conf since other sites might also update
# this file.
mkdir -p "${NGINXDIR}sites-available"
rsync --inplace \
  --checksum \
  --itemize-changes \
  web/default.conf web/llama3-weboftomorrow-com.conf "${NGINXDIR}sites-available/";
echo rsynced web/default.conf web/llama3-weboftomorrow-com.conf to "${NGINXDIR}sites-available/";

mkdir -p "${NGINXDIR}sites-enabled";
ln -sf "${NGINXDIR}sites-available/default.conf" "${NGINXDIR}sites-enabled/default.conf";
ln -sf "${NGINXDIR}sites-available/llama3-weboftomorrow-com.conf"  "${NGINXDIR}sites-enabled/llama3-weboftomorrow-com.conf";

if (test -f web/dhparam.pem); then
mkdir -p "${NGINXDIR}ssl/"
rsync --inplace \
  --checksum \
  --itemize-changes \
  web/dhparam.pem "${NGINXDIR}ssl/dhparam.pem";
fi

# TODO: add stats icon dir to awstats root

# Add crontab file in the cron directory
#ADD crontab /etc/cron.d/awstats

# Give execution rights on the cron job
#RUN chmod 0644 /etc/cron.d/awstats

# Add the conf
#COPY awstats.llama3.weboftomorrow.com.conf /etc/awstats/
