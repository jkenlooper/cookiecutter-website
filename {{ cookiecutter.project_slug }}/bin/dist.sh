#!/usr/bin/env bash
set -eu -o pipefail

# Create a distribution for uploading to a production server.

# archive file path should be absolute
ARCHIVE=$1

TMPDIR=$(mktemp --directory);

git clone . "$TMPDIR";

(
cd "$TMPDIR";

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
)

# Clean up
rm -rf "${TMPDIR}";
