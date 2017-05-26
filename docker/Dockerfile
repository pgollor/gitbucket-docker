FROM anapsix/alpine-java:8
LABEL maintainer "Pascal Gollor <ppascal@pgollor.de>"

ENV GITBUCKET_HOST 0.0.0.0
ENV GITBUCKET_PORT 8080
ENV GITBUCKET_HOME /srv/gitbucket

# set environment
RUN mkdir $GITBUCKET_HOME
WORKDIR $GITBUCKET_HOME

# setup
RUN apk update
RUN apk add ca-certificates wget
RUN wget https://github.com/gitbucket/gitbucket/releases/download/4.12.1/gitbucket.war -O $GITBUCKET_HOME/latest.war

# clean
RUN apk del ca-certificates wget
RUN rm -rf /var/cache/apk/*

CMD java -jar $GITBUCKET_HOME/latest.war --host=$GITBUCKET_HOST --port=$GITBUCKET_PORT --gitbucket.home=$GITBUCKET_HOME 
