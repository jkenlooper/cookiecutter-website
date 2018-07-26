#!/bin/bash


# Sync source files to build server
rsync --archive --progress --itemize-changes \
  api \
  chill \
  certbot \
  package.json \
  README.md \
  root \
  scripts \
  site.cfg \
  stats \
  templates \
  web \
  dev@llama-1:/home/dev/llama/


# Sync built files back to local
rsync --archive --progress --itemize-changes \
  dev@llama-1:/home/dev/llama/{db.dump.sql,node_modules,package-lock.json} \
  ./

rsync --archive --progress --itemize-changes \
  dev@llama-1:/home/dev/llama/web/rootCA.pem \
  ./

