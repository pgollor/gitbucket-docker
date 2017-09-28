# docker container for gitbucket

This docker container of [gitbucket](https://github.com/gitbucket/gitbucket.git) is under testing!!!

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

2. Generate new passwords for your databse!!!
```
./generate_password.sh
```

3. Get latest container:
```
docker-compose pull
```

4. Change the confoguration and start with:
```
docker-compose up -d
```

5. Open `127.0.0.1:8080` and be habby. :-)
Default user and passwort are both root.


### Configuration
Please use the configuration file `gitbucket.conf` for your personal changes.
There are three configs for gitbucket:
- `GITBUCKET_BIND`: ip address to bind to
- `GITBUCKET_WEB_PORT`: web port to bind to
- `GITBUCKET_SSH_PORT`: ssh port to bind to


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



### Plugins
To use plugins download the plugin and move it into `data/plugins`.
After that restart the gitbucket container with `docker-compose restart main-gitbucket`.


### Backup
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


## Contact and Contribution
You can write me an email ( `kalle@pgollor.de` ) or you could register here as an user to contribute to this project.
After register please fork this repository and create pull reqeusts with your changes or add an issue.


## TODO
- check gitbucket.war hash after download
- maybe a nginx container with ssl???


## Inspirations
I got some inspirations for this project from:
- https://github.com/mailcow/mailcow-dockerized


## License
[![cc-bc-sa](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/): Please see [license](LICENSE.md)

[Gitbucket license](https://github.com/gitbucket/gitbucket/blob/master/LICENSE)
