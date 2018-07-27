#!/bin/bash -e

# Run as dev user to install chill and create the db from the dump file.

cd /usr/local/src/llama3-weboftomorrow-com/

virtualenv .

# Install latest chill on develop branch
./bin/pip install https://github.com/jkenlooper/chill/archive/develop.zip

# Create the sqlite database file
cat db.dump.sql | sqlite3 /var/lib/llama3-weboftomorrow-com/sqlite3/db

