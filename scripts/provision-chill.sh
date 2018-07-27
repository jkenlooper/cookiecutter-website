#!/bin/bash -e

SRC_DIR=/usr/local/src/llama3-weboftomorrow-com/

#virtualenv $SRC_DIR

$SRC_DIR/bin/pip install psycopg2
$SRC_DIR/bin/pip install psycopg2

$SRC_DIR/bin/pip install https://github.com/jkenlooper/chill/archive/develop.zip

# Remove and recreate the db from the db.dump.sql.
#rm -f db && cat db.dump.sql | sqlite3 db

