#!/bin/bash -e

ln -sf $PWD/stats/crontab /etc/cron.d/awstats
chmod 0644 /etc/cron.d/awstats

mkdir -p /usr/src/awstats/
(
cd /usr/src/awstats/
curl -O -L https://github.com/eldy/awstats/archive/7.7.tar.gz
tar -xzf 7.7.tar.gz
mkdir -p /usr/run/stats/www/
cp -rf awstats-7.7/wwwroot/icon /usr/run/stats/www/
)
mkdir -p /usr/run/stats/data/

mkdir -p /etc/awstats
ln -sf $PWD/stats/awstats.llama.weboftomorrow.com.conf /etc/awstats/
