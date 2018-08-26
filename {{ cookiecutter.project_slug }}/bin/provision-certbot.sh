#!/usr/bin/env bash

set -eu -o pipefail

# https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx.html

# /srv/llama3-weboftomorrow-com/
SRVDIR=$1

add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install --yes python-certbot-nginx


# Get the cert and place it in the /.well-known/ location from webroot.
certbot certonly \
  --webroot --webroot-path "${SRVDIR}root/" \
  --domain llama3.weboftomorrow.com

# Add the crontab only if not already there.
if (test ! -f /etc/cron.d/certbot-crontab); then
  cp certbot/certbot-crontab /etc/cron.d/
  chmod 0644 /etc/cron.d/certbot-crontab
fi
