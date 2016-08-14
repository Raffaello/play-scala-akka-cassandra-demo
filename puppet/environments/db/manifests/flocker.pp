## need a master node and the agent in the children, like swarm, puppet-master, etc...
#exec { 'clusterHQ repository':
#  command => "yum list installed clusterhq-release || yum install -y https://clusterhq-archive.s3.amazonaws.com/centos/clusterhq-release$(rpm -E %dist).noarch.rpm",
#  cwd => '/tmp',
#  before => Class['docker'],
#  path => '/usr/bin'
#}
#-> exec { 'install flocker-cli':
#  command => 'yum install -y clusterhq-flocker-cli',
#  path => '/usr/bin',
#  before => Class['docker']
#}
#-> exec { '':
#  command => '',
#  path => '/usr/bin',
#  before => Class['docker']
#}
#
#
##-> exec { 'install flocker':
##  command => '/usr/bin/curl -sSL https://get.flocker.io/ | sh',
##  cwd => '/tmp',
##  before => Class['docker']
##}