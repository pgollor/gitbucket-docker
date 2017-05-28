#!/bin/bash

# backup directory
backupDir=./backup
mkdir -p ${backupDir}
mkdir -p ${backupDir}/db
mkdir -p ${backupDir}/repositories

# current date
currentDate=$(date +"%Y-%m-%d_%H-%M-%S")


# backup mysql
dbFile="${backupDir}/db/${currentDate}.sql"
docker-compose exec mysql-gitbucket sh -c 'exec mysqldump --lock-tables --default-character-set=utf8mb4 -uroot -p"${MYSQL_ROOT_PASSWORD}" ${GITBUCKET_DATABASE_NAME}' > ${dbFile}
tar -cj ${dbFile} -f "${dbFile}.tbz2"
rm ${dbFile}

# backup repositories
repoFile="${backupDir}/repositories/${currentDate}.tbz2"
tar -cj data/repositories -f ${repoFile}

# delete all files older 10 days
find ${backupDir} -iname "*.tbz2" -type f -mtime +10 -exec rm {} \; > /dev/null
