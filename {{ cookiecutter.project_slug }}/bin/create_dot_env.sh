#!/usr/bin/env bash
set -e -u -o pipefail

function usage {
  cat <<USAGE
Usage: ${0} [-h]

Options:
  -h            Show help

Creates the .env file used for setting some configuration for the website.
Existing files will be renamed with a .bak suffix.
USAGE
  exit 0;
}

while getopts ":h" opt; do
  case ${opt} in
    h )
      usage;
      ;;
    \? )
      usage;
      ;;
  esac;
done;
shift "$((OPTIND-1))";

read -p "What is your favorite Muppet character (should be one word): " MUPPET_CHARACTER;
echo ""

if [ -f .env ]; then
  mv --backup=numbered .env .env.bak
fi

(
cat <<HERE

# TODO: change this comment to explain how to get these public and secret keys
# for the website (if applicable).
EXAMPLE_PUBLIC_KEY=fill-this-in
EXAMPLE_SECRET_KEY=fill-this-in

# TODO: this is an example of how to set some value from the prompt.
# [List of Muppet characters](https://en.wikipedia.org/wiki/List_of_Muppets).
MUPPET_CHARACTER='${MUPPET_CHARACTER}'

HERE
) > .env

echo "Created .env file with the below contents:"
echo ""
cat .env
echo ""

