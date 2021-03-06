# [WIP] Scala Play! and Akka with Cassandra and Titan

- scala
- play framework ===> move to lagom
- akka
- cassandra DB
- Titan DB ===> [JanushGrap] (http://janusgraph.org/)

- [Dataset](https://archive.ics.uci.edu/ml/datasets/Movie)

## [WIP] configuration using vagrant and puppet

### Vagrant

- Vagrant >= 1.8
- `vagrant plugin install vagrant-vbguest` plugin
- `vagrant plugin install vagrant-puppet-install` plugin
- `vagrant plugin install vagrant-librarian-puppet` plugin 
- VirtualBox >= 5.1 (?)

### Puppet

- Puppet 4.5.3

## Browser sites

- Docker UI => 10.10.10.10:9000 or 127.0.0.1:9000 (disabled, code commented out)
- Consul UI => 10.10.10.10:8500 or 127.0.0.1:8500
- OpsCenter => 10.10.10.10:8888 (disabled, code commented out)
- scala app => 10.10.1.10:80    or 127.0.0.1:8080 (WIP)
- ES        => 10.10.20.1[1|2]:9200/_plugin/kopf/  (reduced to one instance only .11)
- HAProxy   => 10.10.1.10/haproxy?stats

### other IPs

- cassandra => 10.10.30.1[1-3]
- TitanDB   => 10.10.40.11

## [WIP] servers architecture

### DB Environment

- db-vm (management purpose) => docker, dockerSwarm, consul
- Cassandra cluster => general column data store
- Elastic Search cluster => indexes
- TitanDB Cluster => Gremlin Server remoting to Cassandra

### web-vm

- HAProxy
- 2 scala Play! instances load balanced running


### db-vm

It manages the resources of the DB layer architecture, it is a monitor for the DB-tier instances.

### Cassandra

The main DB, a cluster of cassandra, reduced to 1 istance only due to limited HW resources.

### Titandb

1 istance running gremlin server and connect to Cassandra and Elastic search.

### Elastic Search

Indexes for TitanDB.

--------------------------
