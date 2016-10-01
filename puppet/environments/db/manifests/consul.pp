class consulNode {
  class { '::consul':
    config_hash => {
      'bootstrap_expect' => 1,
      #    'bootstrap'        => true,
      'client_addr'      => '0.0.0.0',
      'data_dir'         => '/opt/consul',
      'log_level'        => 'INFO',
      'node_name'        => 'db.dev.consul',
      'server'           => true,
      'ui_dir'           => '/opt/consul/ui',
      'bind_addr'        => "${::ipaddress_eth1}"
    }
  }
}

class consulAgentNode($consulServerIps) {
  class { '::consul':
    config_hash => {
      'data_dir'   => '/opt/consul',
      'log_level'  => 'INFO',
      'node_name'  => $hostname,
      'retry_join' => $consulServerIps
    }
  }
}
