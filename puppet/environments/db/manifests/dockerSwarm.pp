#class { 'consul':
#  config_hash => {
#    'bootstrap_expect' => 1,
#    'data_dir'         => '/opt/consul',
#    'datacenter'       => '0.0.0.0',
#    'log_level'        => 'INFO',
#    'node_name'        => 'consul-server',
#    'bind_addr'        => "${::ipaddress_eth1}"
#    'server'           => true
#  }
#}

#class dockerSwarm {
#  docker::image { 'swarm': image_tag => latest }
#  ::docker::run { 'swarm':
#    image   => 'swarm',
#    command => "join --addr=${::ipaddress_eth1}:2375 consul://${::ipaddress_eth1}:8500/swarm_nodes"
#  }
#}
#
#node 'swarm-1' {
#  include dockerSwarm
#
#  ::docker::run { 'swarm-manager':
#    image   => 'swarm',
#    ports   => '3000:2375',
#    command => "manage consul://${::ipaddress_eth1}:8500/swarm_nodes",
#    require => docker::run['swarm'],
#  }
#
#}
#
#node default {
#  include dockerSwarm
#
#  exec { 'consul join swarm-1':
#    path      => '/usr/local/bin/',
#    require   => Class['consul'],
#    before    => Class['docker'],
#    tries     => 10,
#    try_sleep => 1,
#  }
#}