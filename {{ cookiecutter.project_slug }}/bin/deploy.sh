#!/usr/bin/env bash
set -eu -o pipefail

# TODO: add usage help

FROZENTMP=$(mktemp -d);
tar --directory="${FROZENTMP}" --gunzip --extract -f frozen.tar.gz

# TODO: add bucket if not exist

# Prompt to execute the aws s3 commands
echo aws s3 sync \
  "${FROZENTMP}/frozen/" s3://{{ cookiecutter.s3_object_storage_name }}/ \
  --profile {{ cookiecutter.project_slug }} \
  $@
echo aws s3 sync \
  root/ s3://{{ cookiecutter.s3_object_storage_name }}/ \
  --profile {{ cookiecutter.project_slug }} \
  $@
read -p "execute commands? y/n " -n 1 CONTINUE

# Execute the aws s3 commands
if test $CONTINUE == 'y'; then
aws s3 sync \
  "${FROZENTMP}/frozen/" s3://{{ cookiecutter.s3_object_storage_name }}/ \
  --profile {{ cookiecutter.project_slug }} \
  $@
aws s3 sync \
  root/ s3://{{ cookiecutter.s3_object_storage_name }}/ \
  --profile {{ cookiecutter.project_slug }} \
  $@
fi

rm -rf "${FROZENTMP}";
