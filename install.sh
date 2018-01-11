#!/bin/bash


# get user id
uid=$(id -u)

if [ ! -f "gitbucket.conf" ]; then
	cp gitbucket.conf.example gitbucket.conf

	# replace uid and gid in config file
	sed -i "/^GITBUCKET_USER_ID/c\\\GITBUCKET_USER_ID=${uid}" gitbucket.conf
	
	pw1=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)
	pw2=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

	# replace defautl passwords
	sed -i "/^GITBUCKET_DATABASE_ROOT/c\\\GITBUCKET_DATABASE_ROOT=${pw1}" gitbucket.conf
	sed -i "/^GITBUCKET_DATABASE_PASSWORD/c\\\GITBUCKET_DATABASE_PASSWORD=${pw2}" gitbucket.conf
fi
