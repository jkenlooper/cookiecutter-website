#!/bin/bash -e

# Run as dev user to install python apps and create the db from the dump file.

cd /usr/local/src/llama3-weboftomorrow-com/

virtualenv .

# Install dependencies for python apps
./bin/pip install -r requirements.txt

# Create the sqlite database file
sqlite3 /var/lib/llama3-weboftomorrow-com/sqlite3/db < db.dump.sql

