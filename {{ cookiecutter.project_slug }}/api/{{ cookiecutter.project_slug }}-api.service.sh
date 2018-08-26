#!/usr/bin/env bash

SRCDIR=$1

DATE=$(date)

cat <<HERE

# File generated from $0
# on ${DATE}

[Unit]
Description=API {{ cookiecutter.project_slug }} instance
After=network.target

[Service]
User=dev
Group=dev
WorkingDirectory=$SRCDIR
ExecStart=${SRCDIR}bin/{{ cookiecutter.project_slug }}-api site.cfg

[Install]
WantedBy=multi-user.target

HERE
