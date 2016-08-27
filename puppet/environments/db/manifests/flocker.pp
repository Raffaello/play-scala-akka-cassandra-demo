### need a master node and the agent in the children, like swarm, puppet-master, etc...
#exec { 'clusterHQ repository':
#  command => "yum list installed clusterhq-release || yum install -y https://clusterhq-archive.s3.amazonaws.com/centos/clusterhq-release$(rpm -E %dist).noarch.rpm",
#  cwd => '/tmp',
#  path => '/usr/bin'
#}
##-> exec { 'install flocker-cli':
##  command => 'yum install -y clusterhq-flocker-cli',
##  path => '/usr/bin',
##  before => Class['docker']
##}
#
#  #yum install -y clusterhq-flocker-node
#-> package { 'clusterhq-flocker-node':
#  ensure => present,
#  require => Class['docker']
#}
#
#-> package {'clusterhq-flocker-cli':
#  ensure => present,
#  require => Class['docker']
#}
#
## yum install -y clusterhq-flocker-docker-plugin
#-> package { 'clusterhq-flocker-docker-plugin':
#  ensure => present,
#  require => Class['docker']
#}
#
#-> exec{ 'flocker-ca initialize cassandra-cluster':
#  command => 'flocker-ca initialize cassandra-cluster',
#  path => '/bin',
#  cwd => '/home/vagrant'
#}
#
#-> exec{ "flocker-ca create-control-certificate $hostname":
#  command => "flocker-ca create-control-certificate $hostname",
#  path => '/bin',
#  cwd => '/home/vagrant'
#}
#-> exec { "mkdir /etc/flocker":
#  command => "mkdir /etc/flocker",
#  path => '/bin',
#  unless => '/usr/bin test -d /etc/flocker'
#}
#-> exec { 'copy flocker-certificates':
#  command => "cp control-$hostname-.crt /etc/flocker/control-service.crt \
#  && cp control-$hostname-.key /etc/flocker/control-service.key \
#  && cp cluster.crt /etc/flocker",
#  path => '/bin'
#}
#
#-> file { "/etc/flocker":
#  ensure => 'present',
#  mode => '0700',
#  owner => 'root',
#  group => 'root'
#}
#-> file { "/etc/flocker/*":
#  ensure => 'present',
#  mode => '0600',
#  owner => 'root',
#  group => 'root'
#}
#
#-> exec { 'flocker-ca create-node-certificate':
#  command => 'flocker-ca create-node-certificate',
#  path => '/bin',
#  cwd => '/home/vagrant'
#}
#
