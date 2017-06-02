#!/bin/bash

# get user id
uid=$(id -u)

# replace uid and gid in config file
sed -i "/^GITBUCKET_USER_ID/c\\\GITBUCKET_USER_ID=${uid}" gitbucket.conf
