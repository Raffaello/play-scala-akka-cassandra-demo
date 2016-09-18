#exec { 'yum upgrade':
#  command => '/usr/bin/yum -y upgrade',
#  cwd => '/usr/bin',
#  path => '/usr/bin',
#  logoutput => true,
#  timeout => 0
#}
#-> exec { 'reboot':
#  command => '/usr/sbin/reboot',
#  cwd => '/usr/sbin',
#  path => '/usr/sbin',
#  timeout => 0,
#  unless => "LAST_KERNEL=$(rpm -q --last kernel | perl -pe 's/^kernel-(\\S+).*/\$1/' | head -1); \
#   CURRENT_KERNEL=$(uname -r); \
#   /usr/bin/test \$LAST_KERNEL = \$CURRENT_KERNEL",
#  logoutput => true
#}

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

  #reboot { 'after':
  #  subscribe       => Exec['yum upgrade']
  #}
}

class noSwapNode {
  ### SWAP FILE
  swap_file::files { '/dev/dm-1':
    ensure => absent
  }
  -> exec { 'swapoff -a':
    command => '/usr/sbin/swapoff -a'
   }

  # @TODO Seems not working... do it "manually":
  # https://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-swap-removing.html
}

node 'db.dev' {
  include defaultNode
  include osNode
  include javaNode
  include consulNode
  include dockerNode
  include dockerCassandraNode
  include dockerSwarmNode

  class { '::cassandra::datastax_repo': } ->
  class { '::cassandra': } ->
  class { '::cassandra::opscenter': }
}
