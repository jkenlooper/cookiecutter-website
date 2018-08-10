#!/usr/bin/env bash
set -eu -o pipefail

apt-get --yes install \
  software-properties-common \
  rsync \
  nginx \
  curl

apt-get --yes install \
  python \
  python-dev \
  python-pip \
  sqlite3 \
  python-psycopg2 \
  virtualenv

