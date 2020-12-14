#!/usr/bin/env bash
set -o errexit -o pipefail

# Allow NVM_DIR to not be set
#-o nounset

# Create a distribution for uploading to a production server.

# archive file path should be absolute
ARCHIVE=$1

TMPDIR=$(mktemp --directory);

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || echo 'No nvm found'  # This conditionally loads nvm
nvm --version || echo 'skipping use of nvm'

git clone --recurse-submodules . "$TMPDIR";

(
cd "$TMPDIR";

# Use the node and npm that is set in .nvmrc
nvm use || echo 'skipping use of nvm'

# Build
npm ci; # clean install
npm run build;

# Create symlinks for all files in the MANIFEST.
mkdir -p {{ cookiecutter.project_slug }};
for item in $(cat MANIFEST); do
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
