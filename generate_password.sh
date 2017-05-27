#!/bin/bash

pw1=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)
pw2=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

sed -i "/^GITBUCKET_DATABASE_ROOT/c\\\GITBUCKET_DATABASE_ROOT=${pw1}" gitbucket.conf
sed -i "/^GITBUCKET_DATABASE_PASSWORD/c\\\GITBUCKET_DATABASE_PASSWORD=${pw2}" gitbucket.conf
