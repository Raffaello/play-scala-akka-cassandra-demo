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

## [WIP] servers architecture

- 2/3 micro web services running background processes
- 1 web server for display dashboard, could be shared with one akka instance
- 2 cassandra node running titans

### web-vm

- HAProxy


--------------------------

--------------------------

--------------------------
