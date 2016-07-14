#!/bin/bash

DEFAULT_BACKEND="bdb"

if [ -z "$BACKEND" ]
then
    echo "Backend is not specified explicitly, using default $DEFAULT_BACKEND"
    BACKEND=$DEFAULT_BACKEND
fi

echo "Using $BACKEND backend"

if [ "$BACKEND" == "cassandra" ] ; then
    if [ -z "$CASSANDRA_HOST" ]
    then
        echo "\$CASSANDRA_HOST is not set, using the default name (cassandra)"
    else
        echo "Setting storage.hostname=$CASSANDRA_HOST"
        sed -i "s/storage.hostname=cassandra/storage.hostname=$CASSANDRA_HOST/" /srv/titan-1.0.0-hadoop1/conf/titan-cassandra-es.properties
    fi

    cp /srv/titan-1.0.0-hadoop1/conf/titan-cassandra-es.properties /srv/titan-1.0.0-hadoop1/conf/titan.properties

elif [ "$BACKEND" == "bdb" ] ; then
    cp /srv/titan-1.0.0-hadoop1/conf/titan-bdb-es.properties /srv/titan-1.0.0-hadoop1/conf/titan.properties
fi

if [ -z "$ELASTICSEARCH_HOST" ]; then
    echo "\$ELASTICSEARCH_HOST is not set, using the default name (es)"
else
    echo "Setting index.search.hostname=$ELASTICSEARCH_HOST"
    sed -i "s/index.search.hostname=es/index.search.hostname=$ELASTICSEARCH_HOST/" /srv/titan-1.0.0-hadoop1/conf/titan.properties
fi

echo "Schema policy is $SCHEMA_DEFAULT"
if [ "$SCHEMA_DEFAULT" != "" ]
then
    sed -i "s/schema.default = none/schema.default = $SCHEMA_DEFAULT/" /srv/titan-1.0.0-hadoop1/conf/titan.properties
fi

exec $@
