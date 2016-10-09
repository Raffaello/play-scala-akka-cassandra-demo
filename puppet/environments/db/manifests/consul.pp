#######################################
# !!! SHARED BETWEEN ENVIRONMENTS !!! #
#######################################
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
    version => '0.7.0',
#    download_url => 'https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip',
    config_hash => {
      'data_dir'   => '/opt/consul',
      'log_level'  => 'INFO',
      'node_name'  => $hostname,
      'retry_join' => $consulServerIps,
      'bind_addr'  => $ipaddress_eth1,
    }
  }
}
