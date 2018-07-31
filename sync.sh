#!/bin/bash

REMOTE=$1

# Sync source files to build server
rsync --archive --progress --itemize-changes \
  db.dump.sql \
  package.json \
  site.cfg \
  requirements.txt \
  scripts \
  templates \
  documents \
  queries \
  api \
  dev@$REMOTE:/usr/local/src/llama3-weboftomorrow-com/

# Sync the files that require no further processing.
rsync --archive --progress --itemize-changes \
  root \
  dev@$REMOTE:/srv/llama3-weboftomorrow-com/

rsync --archive --progress --itemize-changes \
  web/web-nginx.development.conf \
  dev@$REMOTE:/etc/nginx/sites-available/llama3-weboftomorrow-com.conf

rsync --archive --progress --itemize-changes \
  web/snippets \
  dev@$REMOTE:/etc/nginx/

rsync --archive --progress --itemize-changes \
  web/server.crt \
  web/server.key \
  web/dhparam.pem \
  dev@$REMOTE:/etc/nginx/ssl/

## Sync built files back to local
#rsync --archive --progress --itemize-changes \
#  dev@$REMOTE:/home/dev/llama/{db.dump.sql,node_modules,package-lock.json} \
#  ./
#
#rsync --archive --progress --itemize-changes \
#  dev@$REMOTE:/home/dev/llama/web/rootCA.pem \
#  ./
#
