#!/bin/bash

# Uninstall and clean up script

shopt -s extglob

SRV_DIR=/srv/llama3-weboftomorrow-com

sudo systemctl stop chill
sudo systemctl disable chill
bin/pip uninstall --yes -r requirements.txt
virtualenv --clear .

rm -rf ${SRV_DIR}/root/!(.well-known|.|..)
