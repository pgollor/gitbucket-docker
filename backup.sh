#!/bin/bash


# backup directory
backupDir=./backup
mkdir -p ${backupDir}
mkdir -p ${backupDir}/db
mkdir -p ${backupDir}/conf
if [ -d "data/data" ]; then
	mkdir -p ${backupDir}/data
fi
if [ -d "data/gist" ]; then
	mkdir -p ${backupDir}/gist
fi
mkdir -p ${backupDir}/repositories

# current date
currentDate=$(date +"%Y-%m-%d_%H-%M-%S")


# backup mysql
dbFile="${backupDir}/db/${currentDate}.sql"
docker-compose exec mysql-gitbucket sh -c 'exec mysqldump --lock-tables --default-character-set=utf8mb4 -uroot -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE}' > ${dbFile}
sed -i "/^mysqldump: \\[Warning\\]/d" ${dbFile}
tar -cj ${dbFile} -f "${dbFile}.tbz2"
rm ${dbFile}

# backup repositories
repoFile="${backupDir}/repositories/${currentDate}.tbz2"
tar -cj data/repositories -f ${repoFile}

# backup config files
tar -cj data/conf -f "${backupDir}/conf/${currentDate}.tbz2"

# backup gist repositories if existing
if [ -d "data/gist" ]; then
	repoFile="${backupDir}/gist/${currentDate}.tbz2"
	tar -cj data/gist -f ${repoFile}
fi

# backup data if existing
if [ -d "data/data" ]; then
	repoFile="${backupDir}/data/${currentDate}.tbz2"
	tar -cj data/data -f ${repoFile}
fi

# delete all files older 10 days
find ${backupDir} -iname "*.tbz2" -type f -mtime +10 -exec rm {} \; > /dev/null
