#!/bin/bash

REMOTE=$1

# Sync source files to build server
rsync --archive --progress --itemize-changes \
  db.dump.sql \
  package.json \
  site.cfg \
  scripts \
  templates \
  documents \
  queries \
  dev@$REMOTE:/usr/local/src/llama3-weboftomorrow-com/

rsync --archive --progress --itemize-changes \
  root \
  dev@$REMOTE:/srv/llama3-weboftomorrow-com/

## Sync built files back to local
#rsync --archive --progress --itemize-changes \
#  dev@$REMOTE:/home/dev/llama/{db.dump.sql,node_modules,package-lock.json} \
#  ./
#
#rsync --archive --progress --itemize-changes \
#  dev@$REMOTE:/home/dev/llama/web/rootCA.pem \
#  ./
#
