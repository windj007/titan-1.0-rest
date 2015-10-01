FROM debian:jessie
MAINTAINER Roman Suvorov windj007@gmail.com

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -yqq openjdk-8-jre-headless wget unzip

RUN wget -O /srv/titan-1.0.0-hadoop1.zip http://s3.thinkaurelius.com/downloads/titan/titan-1.0.0-hadoop1.zip && \
    cd /srv && \
    unzip titan-1.0.0-hadoop1.zip && \
    rm titan-1.0.0-hadoop1.zip

WORKDIR /srv/titan-1.0.0-hadoop1

COPY gremlin-server.yaml conf/gremlin-server/
COPY titan-cassandra-es.properties conf/
COPY entry-point.sh /entry-point.sh

ENTRYPOINT ["/entry-point.sh"]
EXPOSE 8182

CMD ["bin/gremlin-server.sh", "conf/gremlin-server/gremlin-server.yaml"]
