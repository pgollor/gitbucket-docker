# docker container for gitbucket

[![Build Status](https://jenkins.pgollor.de/job/gitbucket-docker-master/badge/icon)](https://jenkins.pgollor.de/job/gitbucket-docker-master/)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/pgollor)
[![Version 4.28.0](https://img.shields.io/badge/gitbucket_version-4.28.0-blue.svg)](https://github.com/gitbucket/gitbucket/releases/tag/4.28.0)

This docker container of [gitbucket](https://github.com/gitbucket/gitbucket.git) is in beta state!


## Table of contents 

  - [Usage](#section-id-5)
    - [Dependencies](#section-id-7)
    - [Installation](#section-id-11)
    - [Configuration](#section-id-38)
    - [Update](#section-id-46)
    - [Plugins](#section-id-71)
    - [Backup](#section-id-76)
  - [Troubleshooting](#section-id-82)
    - [Error 503 on first start](#section-id-84)
  - [Contact and Contribution](#section-id-95)
  - [TODO](#section-id-100)
  - [Inspirations](#section-id-105)
  - [License](#section-id-110)
  

<div id='section-id-5'/>

## Usage

<div id='section-id-7'/>

### Dependencies
- [docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)

<div id='section-id-11'/>

### Update

Please make a backup from the hole directory bevor update your repsitory and commit your changes!

#### from 4.19.3 to 4.20.0
You have to backup your `gitbucket.conf` because this config does not exist in the repository any more.
You have to manage the config file manually.
The new install script will create a local config fiel as copy from `gitbucket.conf.example` and generate new passwords.


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


<div id='section-id-38'/>

### Configuration
Please use the configuration file `gitbucket.conf` for your personal changes.
There are three configs for gitbucket:
- `GITBUCKET_BIND`: ip address to bind to
- `GITBUCKET_WEB_PORT`: web port to bind to
- `GITBUCKET_SSH_PORT`: ssh port to bind to


<div id='section-id-46'/>

### Update
Update your gitbucket image in three steps.
But first of all: **MAKE A BACKUP!!!**

1. Commit your local changes. Changes in `gitbucket.conf` will be ignored!

2. get the new image
Shutdown and remove your images. This will not delete your mysql database volume.
```
docker-compose down
```
After that get the new image and start it:
```
docker-compose pull
docker-compose up -d --remove-orphans
```

3. cleanup your docker environment
This step is optional. Please do this only if you understand the next line.
```
docker rmi -f $(docker images -f "dangling=true" -q)
```



<div id='section-id-71'/>

### Plugins
To use plugins download the plugin and move it into `data/plugins`.
After that restart the gitbucket container with `docker-compose restart main-gitbucket`.


<div id='section-id-76'/>

### Backup
For backuping the mysql database and the repositories you could use the `backup.sh` script and combine it with a daily cronjob.
This script will create a compressed backup and keep the files 10 days in the backup directory.
All files which are older then 10 days will be deleted.


<div id='section-id-82'/>

## Troubleshooting

<div id='section-id-84'/>

### Error 503 on first start
Please check the gitbucket log files with
```
docker-compose logs main-gitbucket
```
If you get `Could not connect to address=(host=172.22.2.251)` as error:
Please restart the gitbucket container with `docker-compose restart main-gitbucket` because the mariadb container needs some time to run completly at the first start.
After that it should be work.
If doesn't please contact me via `issue@pgollor.de` because gitbucket does not allow issues for guests.


<div id='section-id-95'/>

## Contact and Contribution
You can write me an email ( `kalle@pgollor.de` ) or you could register here as an user to contribute to this project.
After register please fork this repository and create pull reqeusts with your changes or add an issue.


<div id='section-id-100'/>

## TODO
- check gitbucket.war hash after download
- maybe a nginx container with ssl???


<div id='section-id-105'/>

## Inspirations
I got some inspirations for this project from:
- https://github.com/mailcow/mailcow-dockerized


<div id='section-id-110'/>

## License
[![cc-bc-sa](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/): Please see [license](LICENSE.md)

[Gitbucket license](https://github.com/gitbucket/gitbucket/blob/master/LICENSE)
