#!/usr/bin/env bash

set -eu -o pipefail

ENVIRONMENT=$1
SRVDIR=$2
NGINXLOGDIR=$3
PORTREGISTRY=$4

# shellcheck source=/dev/null
source "$PORTREGISTRY"

cat <<HERE

server {
  listen 80;
  listen 443 ssl http2;


  ## SSL Params
  # from https://cipherli.st/
  # and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
  ssl_ecdh_curve secp384r1;
  ssl_session_cache shared:SSL:10m;
  ssl_session_tickets off;
  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 8.8.8.8 8.8.4.4 valid=300s;
  resolver_timeout 5s;
  # Disable preloading HSTS for now.  You can use the commented out header line that includes
  # the "preload" directive if you understand the implications.
  #add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
  add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
  add_header X-Frame-Options DENY;
  add_header X-Content-Type-Options nosniff;

  root ${SRVDIR}root;

  access_log  ${NGINXLOGDIR}access.log;
  error_log   ${NGINXLOGDIR}error.log;

  error_page 404 /notfound/;

  location = /humans.txt {}
  location = /robots.txt {}
  location = /favicon.ico {}

  location /stats/ {
    root   ${SRVDIR}stats;
    index  awstats.{{ cookiecutter.site_domain }}.html;
    auth_basic            "Restricted";
    auth_basic_user_file  ${SRVDIR}.htpasswd;
    access_log ${NGINXLOGDIR}access.awstats.log;
    error_log ${NGINXLOGDIR}error.awstats.log;
    rewrite ^/stats/(.*)$  /\$1 break;
  }

  location /api/ {
    proxy_pass_header Server;
    proxy_set_header Host \$http_host;
    proxy_set_header  X-Real-IP  \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    proxy_redirect off;
    #proxy_intercept_errors on;
    proxy_pass http://localhost:${PORTAPI};
    rewrite ^/api/(.*)\$  /\$1 break;
  }

HERE

if test $ENVIRONMENT == 'development'; then

if (test -f web/dhparam.pem); then
cat <<HERE
  ssl_dhparam /etc/nginx/ssl/dhparam.pem;
HERE
fi

cat <<HEREBEDEVELOPMENT
  # certs for localhost only
  ssl_certificate /etc/nginx/ssl/server.crt;
  ssl_certificate_key /etc/nginx/ssl/server.key;

  server_name local-{{ cookiecutter.project_slug }};

  # It is useful to have chill run in dev mode when editing templates. Note
  # that in production it uses the static pages (frozen).
  location / {
    proxy_pass_header Server;
    proxy_set_header Host \$http_host;
    proxy_set_header  X-Real-IP  \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    proxy_redirect off;
    proxy_intercept_errors on;
    proxy_pass http://localhost:${PORTCHILL};
  }
HEREBEDEVELOPMENT

else

if test -e .has-certs; then
cat <<HEREENABLESSLCERTS
  # certs created from certbot
  ssl_certificate /etc/letsencrypt/live/{{ cookiecutter.site_domain }}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/{{ cookiecutter.site_domain }}/privkey.pem;
HEREENABLESSLCERTS
else
cat <<HERETODOSSLCERTS
  # certs can be created from running 'bin/provision-certbot.sh ${SRVDIR}'
  # TODO: uncomment after they exist
  #ssl_certificate /etc/letsencrypt/live/{{ cookiecutter.site_domain }}/fullchain.pem;
  #ssl_certificate_key /etc/letsencrypt/live/{{ cookiecutter.site_domain }}/privkey.pem;
HERETODOSSLCERTS
fi

cat <<HEREBEPRODUCTION

  server_name {{ cookiecutter.site_domain }};

  location /.well-known/ {
    try_files \$uri =404;
  }

  location / {
    root ${SRVDIR}frozen;
  }
HEREBEPRODUCTION
fi

cat <<HERE
}
HERE
