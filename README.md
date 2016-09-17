# [WIP] Scala Play! and Akka with Cassandra and Titan

- scala
- play (lagom) framework 
- akka
- cassandra DB
- Titan DB

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

- Docker UI => 10.10.10.10:9000 or 127.0.0.1:9000
- Consul UI => 10.10.10.10:8500 or 127.0.0.1:8500
- scala app => 10.10.1.10:80    or 127.0.0.1:8080
- ES        => 10.10.20.1[1|2]:9200/_plugin/kopf/

### other IPs

- cassandra titan => 10.10.30.1[1-3]
- TitanDB   => 10.10.40.11

## [WIP] servers architecture

### DB Environment

- db-vm => docker, dockerSwarm, consul, (management purpose)
- Cassandra cluster => general column data store
- Elastic Search cluster => indexes
- TitanDB Cluster => Gremlin Server remoting to Cassandra

### web-vm

- HAProxy

### db-vm

### cassandra


### titandb

### es


--------------------------

--------------------------

--------------------------
