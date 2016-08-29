class dockerSwarmNode {
  #class dockerSwarm {
  #  docker::image { 'swarm': image_tag => latest }
  #  ::docker::run { 'swarm':
  #    image   => 'swarm',
  #    command => "join --addr=${::ipaddress}:2375 consul://${::ipaddress}:8500/swarm_nodes"
  #  }
  #}

  ::docker::image { 'swarm': image_tag => latest }
  ::docker::run { 'swarm-consul-join':
    image   => 'swarm',
    command => "join --addr=${::ipaddress}:2375 consul://${::ipaddress}:8500/swarm_nodes"
  }
  ->
  ::docker::run { 'swarm-manager':
    image   => 'swarm',
    ports   => '3000:2375',
    command => "manage consul://${ipaddress}:8500/swarm_nodes"
  }

  exec { 'consul join db.dev':
    path      => '/usr/local/bin/',
    require   => Class['consul'],
    before    => Class['docker'],
    tries     => 10,
    try_sleep => 1
  }

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
}
