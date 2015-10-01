#!/bin/bash

if [ -z "$CASSANDRA_HOST" ]; then
    echo "\$CASSANDRA_HOST is not set, using the default name (cassandra)"
else
    sed -i "s/storage.hostname=cassandra/storage.hostname=$CASSANDRA_HOST/" /srv/titan-1.0.0-hadoop1/conf/titan-cassandra-es.properties
fi

if [ -z "$ELASTICSEARCH_HOST" ]; then
    echo "\$ELASTICSEARCH_HOST is not set, using the default name (es)"
else
    sed -i "s/index.search.hostname=es/index.search.hostname=$ELASTICSEARCH_HOST/" /srv/titan-1.0.0-hadoop1/conf/gremlin-server/gremlin-server.yaml
fi

exec $@
