#!/usr/bin/env bash
set -eu -o pipefail

# Create a distribution for uploading to a production server.

ARCHIVE=$1

# Create symlinks for all files in the MANIFEST.
for item in $(cat {{ cookiecutter.project_slug }}/MANIFEST); do
  dirname "{{ cookiecutter.project_slug }}/${item}" | xargs mkdir -p;
  dirname "{{ cookiecutter.project_slug }}/${item}" | xargs ln -sf "${PWD}/${item}";
done;

tar --dereference \
  --exclude=MANIFEST \
  --create \
  --auto-compress \
  --file "${ARCHIVE}" {{ cookiecutter.project_slug }};

