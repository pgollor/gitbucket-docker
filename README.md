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


### Plugins
To use plugins download the plugin and move it into `data/plugins`.
After that restart the gitbucket container with `docker-compose restart main-gitbucket`.


### Backup
For backuping the mysql database and the repositories you could use the `backup.sh` script and combine it with a daily cronjob.
This script will create a compressed backup and keep the files 10 days in the backup directory.
All files which are older then 10 days will be deleted.


## TODO
- wait for the next update and write an update howto
- maybe a nginx container with ssl???


## Inspirations
I got some inspirations for this project from:
- https://github.com/mailcow/mailcow-dockerized


## License
[License](LICENSE.md)
