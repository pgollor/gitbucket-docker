#!/bin/bash


# backup directory
backupDir=./backup

# current date
currentDate=$(date +"%Y-%m-%d_%H-%M-%S")

# check for first parameter
if [[ ! ${1} =~ (backup|restore) ]]; then
	echo "First parameter needs to be 'backup' or 'restore'"
	exit 1
fi

if [[ ${1} == "backup" && ! ${2} =~ (db|repos|confs|gist|data|sshkeys|all) ]]; then
	echo "Second parameter needs to be 'db', 'repos', 'confs', 'gist', 'data', 'sshkeys' or 'all'"
	exit 1
fi


# create backup directories
mkdir -p ${backupDir}
mkdir -p ${backupDir}/db
mkdir -p ${backupDir}/conf
mkdir -p ${backupDir}/repositories
if [ -d "data/data" ]; then
	mkdir -p ${backupDir}/data
fi
if [ -d "data/gist" ]; then
	mkdir -p ${backupDir}/gist
fi


function backup() {

	IDmain=$(docker ps -qf name=main-gitbucket)
	IDdb=$(docker ps -qf name=mysql-gitbucket)

	while (( "$#" )); do
	case "$1" in
	db|all)

		echo "backup database"
		dbFile="${backupDir}/db/${currentDate}.sql"
		docker exec $IDdb sh -c 'exec mysqldump --lock-tables --default-character-set=utf8mb4 -uroot -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE}' > ${dbFile}
		sed -i "/^mysqldump: \\[Warning\\]/d" ${dbFile}
		tar -cj ${dbFile} -f "${dbFile}.tbz2"
		rm ${dbFile}

	;;&
	repos|all)

		echo "backup repositories"
		repoFile="${backupDir}/repositories/${currentDate}.tbz2"
		tar -cj data/repositories -f ${repoFile}

		# copy auto backup folder
		if [ -d "data/backup" ]; then
			cp -R data/backup "${backupDir}/autoBackup"
		fi

	;;&
	confs|all)

		echo "backup config files"
		tar -cj data/conf gitbucket.conf -f "${backupDir}/conf/${currentDate}.tbz2"

	;;&
	gist|all)
	
		if [ -d "data/gist" ]; then
			echo "backup gist directory"
			repoFile="${backupDir}/gist/${currentDate}.tbz2"
			tar -cj data/gist -f ${repoFile}
		fi

	;;&
	data|all)

		if [ -d "data/data" ]; then
			echo "backup data directory"
			repoFile="${backupDir}/data/${currentDate}.tbz2"
			tar -cj data/data -f ${repoFile}
		fi

	;;&
	sshkeys|all)

		echo "try to backup ssh keys if available"
		docker cp ${IDmain}:/srv/gitbucket/gitbucket.ser "${backupDir}/gitbucket.ser" 2> /dev/null

	;;
	esac
	shift
	done

	# delete all files older 10 days
	#find ${backupDir} -iname "*.tbz2" -type f -mtime +10 -exec rm {} \; > /dev/null
}

function restore() {
	while (( "$#" )); do
	case "$1" in
	sshkeys|all)

	if [ ! -f "${backupDir}/gitbucket.ser" ]; then
		echo "${backupDir}/gitbucket.ser does not exist"
		exit 1
	fi

	IDmain=$(docker ps -qf name=main-gitbucket)

	echo "restore ssh keys"
	docker cp "${backupDir}/gitbucket.ser" ${IDmain}:/srv/gitbucket/gitbucket.ser

	;;
	esac
	shift
	done
}

if [[ ${1} == "backup" ]]; then
	backup ${@,,}
elif [[ ${1} == "restore" ]]; then
	restore ${@,,}
fi

