#!/bin/bash

# Run from your local machine to create certs for development.

# TODO: create the .htpasswd file
touch .htpasswd;

openssl genrsa -out web/local-{{ cookiecutter.project_slug }}-CA.key 2048

openssl req -x509 -new -nodes \
  -key web/local-{{ cookiecutter.project_slug }}-CA.key \
  -sha256 -days 99999 \
  -config web/local-{{ cookiecutter.project_slug }}-CA.cnf \
  -out web/local-{{ cookiecutter.project_slug }}-CA.pem


openssl req -new -sha256 -nodes -newkey rsa:2048 \
	-config web/local-{{ cookiecutter.project_slug }}.csr.cnf \
	-out web/local-{{ cookiecutter.project_slug }}.csr \
	-keyout web/local-{{ cookiecutter.project_slug }}.key

openssl x509 -req -CAcreateserial -days 99999 -sha256 \
	-in web/local-{{ cookiecutter.project_slug }}.csr \
	-CA web/local-{{ cookiecutter.project_slug }}-CA.pem \
	-CAkey web/local-{{ cookiecutter.project_slug }}-CA.key \
	-out web/local-{{ cookiecutter.project_slug }}.crt \
	-extfile web/v3.ext


#openssl dhparam -out web/dhparam.pem 2048
