# titan-1.0-rest
A very simple image that runs [Titan graph database v1.0.0](http://thinkaurelius.github.io/titan/) and exposes its functionality via REST using Gremlin-Server. Initially intended for use with Python, but can by used with any other clients.

# Examples

## Basic Usage - Cassandra
    # run indexing dependencies
    docker run -d --name test_cassandra spotify/cassandra
    docker run -d --name test_es elasticsearch:1.5
    
    # run titan
    docker run -d --name test_titan \
        --link test_cassandra:cassandra \
        --link test_es:es \
        -e "BACKEND=cassandra" \
        -e "SCHEMA_DEFAULT=default" \
        windj007/titan-rest
    
    # test
    export TITAN_IP=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' test_titan`
    curl "http://$TITAN_IP:8182/?gremlin=g.V().count()"


## Basic Usage - BerkeleyDB
    # run indexing dependencies
    docker run -d --name test_es elasticsearch:1.5
    
    # run titan
    docker run -d --name test_titan \
        --link test_es:es \
        -e "BACKEND=bdb" \
        -e "SCHEMA_DEFAULT=default" \
        -v /tmp/data:/data \
        windj007/titan-rest
    
    # test
    export TITAN_IP=`docker inspect -f '{{ .NetworkSettings.IPAddress }}' test_titan`
    curl "http://$TITAN_IP:8182/?gremlin=g.V().count()"


## Custom linking
Sometimes it can be useful to not to use Docker linking, e.g. to optimize network performance or when Cassandra and ES are running on other servers. In this case, one can tell docker to use host NIC and explicitly specify hostnames or IP addresses of Cassandra and ES instances.

    # run indexing dependencies
    docker run -d --net=host --name test_cassandra spotify/cassandra
    docker run -d --net=host --name test_es elasticsearch
    
    # run titan
    docker run -d --net=host --name test_titan -e CASSANDRA_HOST=localhost -e ELASTICSEARCH_HOST=localhost windj007/titan-rest
    
    # test
    curl "http://localhost:8182/?gremlin=g.V().count()"

# Environment Options

Image supports the following options:

* BACKEND={bdb,cassandra} - which backend to use. If bdb is chosen, you should map some folder from host to persist data (see BDB example).
* SCHEMA_DEFAULT={none,default} - whether to allow automatic schema inference or not. Default is none, which requires explicit schema specification before use.
* HPROF_OPTIONS - options to -Xrunhprof[:options].
* JAVA_XMX - max heap for JVM.