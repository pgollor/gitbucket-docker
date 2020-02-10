# docker container for gitbucket

[![Build Status](https://jenkins.pgollor.de/job/gitbucket-docker-master/badge/icon)](https://jenkins.pgollor.de/job/gitbucket-docker-master/)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/pgollor)
[![Docker Pulls](https://img.shields.io/docker/pulls/pgollor/gitbucket.svg)](https://hub.docker.com/r/pgollor/gitbucket/)
[![](https://images.microbadger.com/badges/image/pgollor/gitbucket.svg)](https://microbadger.com/images/pgollor/gitbucket "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/pgollor/gitbucket.svg)](https://microbadger.com/images/pgollor/gitbucket "Get your own version badge on microbadger.com")
[![](https://img.shields.io/github/tag-date/gitbucket/gitbucket.svg?label=gitbucket%20latest)](https://github.com/gitbucket/gitbucket/releases/latest)

This docker container of [gitbucket](https://github.com/gitbucket/gitbucket.git) is in beta state!


## Table of contents 

  - [Usage](#usage)
    - [Dependencies](#dependencies)
    - [Installation](#installation)
    - [Configuration](#configuration)
    - [Update](#update)
    - [Plugins](#plugins)
    - [Backup](#backup)
  - [Troubleshooting](#troubleshooting)
    - [Error 503 on first start](#error-503-on-first-start)
  - [Contact and Contribution](#contact-and-contribution)
  - [TODO](#todo)
  - [Inspirations](#inspirations)
  - [License](#license)
  

## Usage

### Dependencies
- [docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)


### Installation

1. Get code from repository:
```
git clone https://gitbucket.pgollor.de/git/docker/gitbucket.git
cd gitbucket
```

2. Execute install script
```
./install.sh
```

3. Change the confoguration and start with:
```
docker-compose up -d
```

4. Open `127.0.0.1:8080` and be habby. :-)
Default user and passwort are both root.


### Configuration
Please use the configuration file `gitbucket.conf` for your personal changes.


### Update
Update your gitbucket image in three steps.
But first of all: **MAKE A BACKUP!!!**
Without backup the host ssh keys will be lost.

#### from 4.19.3 to 4.20.0
You have to backup your `gitbucket.conf` because this config does not exist in the repository any more.
You have to manage the config file manually.
The new install script will create a local config fiel as copy from `gitbucket.conf.example` and generate new passwords.

#### from 4.27.0 to 4.28.0

To prevent error messages (like: `[Warning] InnoDB: Table mysql/innodb_table_stats has length mismatch in the column name table_name.  Please run mysql_upgrade`) for mariadb.
Go to the directory where the `docker-compose.yml` file is located and execute the following commands:

```
source gitbucket.conf
docker-compose exec mysql-gitbucket sh -c 'exec mysql_upgrade -uroot -p"${MYSQL_ROOT_PASSWORD}"'
```

#### do update

1. Commit your local changes. Changes in `gitbucket.conf` will be ignored! Pull changes from repository master via `git pull` or `git merge`.

2. Backup
```
./ backup_and_restore.sh backup all
```

3. get the new image
Shutdown and remove your images. This will not delete your mysql database volume.
```
docker-compose down
```
After that get the new image and start it:
```
docker-compose pull
docker-compose up -d --remove-orphans
```

4. cleanup your docker environment
This step is optional. Please only do this if you understand the next line.
```
docker rmi -f $(docker images -f "dangling=true" -q)
```

5. restore ssh keys
```
./ backup_and_restore.sh restore sshkeys
```


### Plugins
To use plugins download the plugin and move it into `data/plugins`.
After that restart the gitbucket container with `docker-compose restart main-gitbucket`.


### Backup

Since 4.30.0 the backupplugin is included.
Automatic backup for repository works, but the E-Mail notification does not work yet.
If you want a full backup, please use `backup.sh` like:

```
./backup.sh backup all
```

- **Plese check if `COMPOSE_PROJECT_NAME` exists in your local `gitbucket.conf`!!!**
- **You have to be install the pbzip2 package!** For debian systems: `apt-get install pbzip2`

#### Full Backup via `backup.sh`
For backuping the mysql database and the repositories you could use the `backup.sh` script and combine it with a daily cronjob.
This script will create a compressed backup and keep the files 10 days in the backup directory.
All files which are older then 10 days will be deleted.


## Troubleshooting

### Error 503 on first start
Please check the gitbucket log files with
```
docker-compose logs main-gitbucket
```
If you get `Could not connect to address=(host=172.22.2.251)` as error:
Please restart the gitbucket container with `docker-compose restart main-gitbucket` because the mariadb container needs some time to run completly at the first start.
After that it should be work.
If doesn't please contact me via `issue@pgollor.de` because gitbucket does not allow issues for guests.

### until commit 5b1fbf92174d914a4546910c7eb55f66527d859b

You have to remove the gitbucket-network once, because this network is no longer port of the docker-compose file


## Contact and Contribution
You can write me an email ( `kalle@pgollor.de` ) or you could register here as an user to contribute to this project.
After register please fork this repository and create pull reqeusts with your changes or add an issue.


## TODO
- restore for all backuped data
- check gitbucket.war hash after download
- maybe a nginx container with ssl???


## Inspirations
I got some inspirations for this project from:
- https://github.com/mailcow/mailcow-dockerized


## License
[![cc-bc-sa](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/): Please see [license](LICENSE.md)

[Gitbucket license](https://github.com/gitbucket/gitbucket/blob/master/LICENSE)
