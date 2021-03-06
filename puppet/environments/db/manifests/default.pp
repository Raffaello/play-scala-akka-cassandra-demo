#######################################
# !!! SHARED BETWEEN ENVIRONMENTS !!! #
#######################################
class defaultNode {
  package { 'unzip':
    ensure => present
  }

  package {'epel-release':
    ensure => present
  }
  -> package { 'htop':
    ensure => present
  }
  -> package { 'vim':
    ensure => present
  }
}

class noSwapNode {
  ### SWAP FILE
  swap_file::files { '/dev/dm-1':
    ensure => absent
  }
  -> exec { 'swapoff -a':
    command => '/usr/sbin/swapoff -a'
   }
}

node 'db.dev' {
  include defaultNode
  include osNode
  include javaNode
  include consulNode
  #include dockerNode
  #include dockerCassandraNode
  #include dockerSwarmNode

  ### need ver 6.x for cassandra 3.x
#  class { '::cassandra::datastax_repo': } ->
#  class { '::cassandra': } ->
#  class { '::cassandra::opscenter': }
}

node 'web.dev' {
  include defaultNode
  include osNode
  include scalaNode
  include haproxyNode

  class { 'consulAgentNode':
    consulServerIps => ['10.10.10.10']
  }
  ::consul::service { 'haproxy':
    checks  => [
      {
        script   => 'systemctl status haproxy.service  -l',
        interval => '30s'
      }
    ],
    port    => 80,
    tags    => ['web']
  }
}
