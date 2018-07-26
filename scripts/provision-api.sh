#!/bin/bash -e

pip2 install --upgrade pip
pip2 install virtualenv

virtualenv .

./bin/pip install psycopg2

./bin/pip install -r api/requirements.txt


