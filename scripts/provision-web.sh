#!/bin/bash -e

# Run as root to create web service

apt-get --yes update
apt-get --yes install nginx

rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/conf.d/*
chown -R dev:dev /etc/nginx/conf.d

mkdir -p /etc/nginx/snippets/
chown -R dev:dev /etc/nginx/snippets

mkdir -p /etc/nginx/ssl/
chown -R dev:dev /etc/nginx/ssl

#ln -s $PWD/$NGINX_CONF /etc/nginx/conf.d/

NGINX_CONF=$1
if test ! $NGINX_CONF; then
  read -p "Set the nginx conf path (web/web-nginx.development.conf): " NGINX_CONF
  if test ! $NGINX_CONF; then
    exit 1
  fi
fi



rm -rf /etc/nginx/snippets
ln -s $PWD/web/snippets /etc/nginx/

mkdir -p /etc/nginx/ssl
ln -s $PWD/web/server.crt /etc/nginx/ssl/
ln -s $PWD/web/server.key /etc/nginx/ssl/
ln -s $PWD/web/dhparam.pem /etc/nginx/ssl/

mkdir -p /www/
ln -s $PWD/root /www/

mkdir -p /www/logs

ln -s $PWD/.htpasswd /www/
