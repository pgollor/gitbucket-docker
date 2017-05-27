#!/bin/bash

# replace mysql settings in config file
dbfile=${GITBUCKET_HOME}/database.config
sed -i "/GITBUCKET_DATABASE_NAME/c\\${GITBUCKET_DATABASE_NAME};" $dbfile
sed -i "/GITBUCKET_DATABASE_HOST/c\\${GITBUCKET_DATABASE_HOST};" $dbfile
sed -i "/GITBUCKET_DATABASE_PASSWORD/c\\${GITBUCKET_DATABASE_PASSWORD};" $dbfile
sed -i "/GITBUCKET_DATABASE_USER/c\\${GITBUCKET_DATABASE_USER};" $dbfile


# start gitbucket
