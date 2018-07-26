#!/bin/bash -e

pip2 install --upgrade pip
pip2 install virtualenv

virtualenv .

./bin/pip install psycopg2

./bin/pip install chill/

# Remove and recreate the db from the db.dump.sql.
#rm -f db && cat db.dump.sql | sqlite3 db

