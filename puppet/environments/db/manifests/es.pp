class esNode ($net_host, $es_version='2.4.0')
{
  include defaultNode
  ### problem provisioning, not enough ram
#  include noSwapNode
  exec {'swappines':
    command => '/sbin/sysctl vm.swappiness=10'
  }
  include javaNode

  package { 'wget':
    ensure => present
  }

  $config_hash = {
    'ES_HEAP_SIZE' => '128M',
    'ES_MAX_HEAP_SIZE' => '128M'
  }

  # semanage port -a -t syslogd_port_t -p tcp 9200
  selinux::port { 'es port':
    context  => 'syslogd_port_t',
    protocol => 'tcp',
    port     => '9200',
  }
  -> selinux::port { 'es port2':
    context  => 'syslogd_port_t',
    protocol => 'tcp',
    port     => '9300',
  }
  -> selinux::port { 'es multicast':
    context  => 'syslogd_port_t',
    protocol => 'tcp',
    port     => '54328',
  }
  # sysctl -w vm.max_map_count=262144
  -> sysctl { 'vm.max_map_count':
    ensure    => 'present',
    permanent => 'yes',
    value     => '262144',
  }
  -> sysctl { 'fs.file-max':
    ensure => 'present',
    permanent => 'yes',
    value => '65535'
  }

  #elasticsearch soft memlock unlimited
  #elasticsearch hard memlock unlimited
  -> limits::fragment {
    "elasticsearch/soft/memlock":
      value => "unlimited";
    "elasticsearch/hard/memlock":
      value => "unlimited";
  }

  -> class { 'elasticsearch':
    java_install      => false,
    package_url       => "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/$es_version/elasticsearch-$es_version.rpm",
    restart_on_change => true,
#    restart_config_change => true,
#    restart_plugin_change => true,
#    restart_package_change => true,
    autoupgrade       => false,
    require           => Package['wget'],
    init_defaults     => $config_hash,
    config            => {
      'cluster.name' => 'TitanDB_Index',
      'network.host' => "$net_host",
      'bootstrap.memory_lock' => true,
      #'discovery.zen.ping.multicast.enabled' => true,
      "discovery.zen.ping.multicast.enabled" => false,
      "discovery.zen.ping.unicast.hosts" => ["10.10.20.11"]
    },
    #ensure => present,
    #status => enabled
  }

  elasticsearch::instance { $hostname: }
  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    instances => $hostname
  }
}

node /^es-0(\d+)$/
{
  include osNode

  class { 'esNode':
    net_host   => "10.10.20.1$1",
    es_version => '2.4.0'
  }

  class { 'consulAgentNode':
    consulServerIps => ['10.10.10.10']
  }
  ::consul::service { "$hostname":
    checks  => [
      {
        script   => "/bin/systemctl status elasticsearch-$hostname.service",
        interval => '30s'
      },
      {
        script => "curl $ipaddress_eth1:9200/_cat/health",
        interval => '30s'
      }
    ],
    port    => 9200,
    tags    => ['elastic-search']
  }
}
