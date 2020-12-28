FROM openjdk:14-alpine
LABEL maintainer "Pascal Gollor <pascal@pgollor.de>"

ARG VCS_REF

LABEL org.label-schema.vcs-url="https://gitbucket.pgollor.de/docker/gitbucket" \
	org.label-schema.vcs-ref=$VCS_REF

# ports
EXPOSE 29418/tcp
EXPOSE 8080/tcp

# environment variables
ENV GITBUCKET_USER_ID 1000
ENV GITBUCKET_HOST 0.0.0.0
ENV GITBUCKET_PORT 8080
ENV GITBUCKET_HOME /srv/gitbucket
ENV GITBUCKET_MAX_FILE_SIZE=10485760

# create home
RUN mkdir -p $GITBUCKET_HOME

# setup
RUN apk update
RUN apk add ca-certificates wget su-exec git
RUN update-ca-certificates

# get gitbucket
RUN wget https://github.com/gitbucket/gitbucket/releases/download/4.35.1/gitbucket.war -O $GITBUCKET_HOME/latest.war

# create plugin dir
RUN mkdir $GITBUCKET_HOME/plugins

# get backup plugin
RUN wget https://github.com/jyuch/gitbucket-backup-plugin/releases/download/1.2.2/gitbucket-backup-plugin-1.2.2.jar -O $GITBUCKET_HOME/gitbucket-backup-plugin-1.2.2.jar

# clean
RUN apk del wget
RUN rm -rf /var/cache/apk/*

# mark volumes
VOLUME $GITBUCKET_HOME/repositories
VOLUME $GITBUCKET_HOME/data
VOLUME $GITBUCKET_HOME/gist
VOLUME $GITBUCKET_HOME/plugins
VOLUME $GITBUCKET_HOME/backup

# set environment
WORKDIR $GITBUCKET_HOME

# copy files
COPY docker-entrypoint.sh /
COPY database.conf ./
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD su-exec gitbucket java -jar $GITBUCKET_HOME/latest.war --host=$GITBUCKET_HOST --port=$GITBUCKET_PORT --gitbucket.home=$GITBUCKET_HOME --max_file_size=$GITBUCKET_MAX_FILE_SIZE
