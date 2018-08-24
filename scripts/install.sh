#!/usr/bin/env bash
set -eu -o pipefail

# development or production
#ENVIRONMENT=$1

# /srv/llama3-weboftomorrow-com/
SRVDIR=$1

# /etc/nginx/
NGINXDIR=$2

# /var/log/nginx/llama3-weboftomorrow-com/
NGINXLOGDIR=$3

# /var/log/awstats/llama3-weboftomorrow-com/
AWSTATSLOGDIR=$4

# /etc/systemd/system/
SYSTEMDDIR=$5

mkdir -p "${SRVDIR}root/";
#chown -R dev:dev "${SRVDIR}root/";
rsync --archive \
  --inplace \
  --delete \
  --exclude=.well-known \
  --itemize-changes \
  root/ "${SRVDIR}root/";
echo "rsynced files in root/ to ${SRVDIR}root/";

mkdir -p "${NGINXLOGDIR}";

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

rsync --inplace \
  --checksum \
  --itemize-changes \
  .htpasswd "${SRVDIR}";

if (test -f web/dhparam.pem); then
mkdir -p "${NGINXDIR}ssl/"
rsync --inplace \
  --checksum \
  --itemize-changes \
  web/dhparam.pem "${NGINXDIR}ssl/dhparam.pem";
fi

# Create the root directory for stats. The awstats icons will be placed there.
mkdir -p "${SRVDIR}stats"

if (test -d /usr/share/awstats/icon); then
rsync --archive \
  --inplace \
  --checksum \
  --itemize-changes \
  /usr/share/awstats/icon "${SRVDIR}stats/";
fi

mkdir -p "${AWSTATSLOGDIR}"

# Add crontab file in the cron directory
cp stats/awstats.llama3-weboftomorrow-com.crontab /etc/cron.d/
chmod 0644 /etc/cron.d/awstats.llama3-weboftomorrow-com.crontab

# Add the awstats conf
cp stats/awstats.llama3.weboftomorrow.com.conf /etc/awstats/

mkdir -p "${SYSTEMDDIR}"
cp chill/llama3-weboftomorrow-com-chill.service "${SYSTEMDDIR}"
systemctl start llama3-weboftomorrow-com-chill || echo "can't start service"
systemctl enable llama3-weboftomorrow-com-chill || echo "can't enable service"
