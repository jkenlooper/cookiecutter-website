#!/bin/bash

# https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx.html

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install --yes python-certbot-nginx


# Get the cert and place it in the /.well-known/ location from webroot.
sudo certbot certonly \
  --webroot --webroot-path /srv/llama3-weboftomorrow-com/root \
  --domain llama3.weboftomorrow.com
