#!/bin/bash
set -e

# check for exisitng user and create it if necessary
USER_ID=${GITBUCKET_USER_ID:-9000}
echo "gitbucket user id: $USER_ID"
if ! id -u gitbucket >/dev/null 2>&1; then
	echo "create gitbucket user"
	adduser -u $USER_ID -D -g '' -h ${GITBUCKET_HOME} gitbucket
fi

# update user rights
chown -R gitbucket:gitbucket ${GITBUCKET_HOME}

# replace mysql settings in config file
dbfile=${GITBUCKET_HOME}/database.conf
sed -i "s/GITBUCKET_DATABASE_NAME/${GITBUCKET_DATABASE_NAME}/" $dbfile
sed -i "s/GITBUCKET_DATABASE_HOST/${GITBUCKET_DATABASE_HOST}/" $dbfile
sed -i "s/GITBUCKET_DATABASE_PASSWORD/${GITBUCKET_DATABASE_PASSWORD}/" $dbfile
sed -i "s/GITBUCKET_DATABASE_USER/${GITBUCKET_DATABASE_USER}/" $dbfile

wget https://github.com/jyuch/gitbucket-backup-plugin/releases/download/1.2.1/gitbucket-backup-plugin-gitbucket_4.29.0-1.2.1.jar -O $GITBUCKET_HOME/plugins/gitbucket-backup-plugin-gitbucket_4.29.0-1.2.1.jar

exec "$@"
