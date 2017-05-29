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


## TODO
- maybe a nginx container with ssl???


## Inspirations
I got some inspirations for this project from:
- https://github.com/mailcow/mailcow-dockerized


## License
[License](LICENSE.md)
