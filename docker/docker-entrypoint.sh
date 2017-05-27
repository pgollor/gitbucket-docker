#!/bin/bash
set -e

# replace mysql settings in config file
dbfile=${GITBUCKET_HOME}/database.conf
sed -i "s/GITBUCKET_DATABASE_NAME/${GITBUCKET_DATABASE_NAME}/" $dbfile
sed -i "s/GITBUCKET_DATABASE_HOST/${GITBUCKET_DATABASE_HOST}/" $dbfile
sed -i "s/GITBUCKET_DATABASE_PASSWORD/${GITBUCKET_DATABASE_PASSWORD}/" $dbfile
sed -i "s/GITBUCKET_DATABASE_USER/${GITBUCKET_DATABASE_USER}/" $dbfile

exec "$@"
