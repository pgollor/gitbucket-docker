FROM anapsix/alpine-java:8
LABEL maintainer "Pascal Gollor <pascal@pgollor.de>"

ENV GITBUCKET_HOST 0.0.0.0
ENV GITBUCKET_PORT 8080
ENV GITBUCKET_HOME /srv/gitbucket

# mark voulmes
VOLUME $GITBUCKET_HOME/repositories
VOLUME $GITBUCKET_HOME/plugins

# set environment
#RUN mkdir $GITBUCKET_HOME
WORKDIR $GITBUCKET_HOME

# setup
RUN apk update
RUN apk add ca-certificates wget
RUN wget https://github.com/gitbucket/gitbucket/releases/download/4.13/gitbucket.war -O $GITBUCKET_HOME/latest.war

# clean
RUN apk del ca-certificates wget
RUN rm -rf /var/cache/apk/*

# copy files
COPY docker-entrypoint.sh /
COPY database.conf ./

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD java -jar $GITBUCKET_HOME/latest.war --host=$GITBUCKET_HOST --port=$GITBUCKET_PORT --gitbucket.home=$GITBUCKET_HOME
