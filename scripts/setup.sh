#!/usr/bin/env bash
set -eu -o pipefail

apt-get --yes install \
  software-properties-common \
  rsync \
  nginx \
  cron \
  curl

apt-get --yes install \
  python \
  python-dev \
  python-pip \
  sqlite3 \
  python-psycopg2 \
  virtualenv

apt-get --yes install \
  awstats
