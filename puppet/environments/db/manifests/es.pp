class esNode ($net_host, $es_version='2.4.0')
{
  include defaultNode
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

  -> class { 'elasticsearch':
    java_install      => false,
    package_url       => "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/$es_version/elasticsearch-$es_version.rpm",
    restart_on_change => true,
    autoupgrade       => false,
    require           => Package['wget'],
    init_defaults     => $config_hash,
    config            => {
      'cluster.name' => 'TitanDB_Index',
      'network.host' => "$net_host",
      'bootstrap.memory_lock' => true,
      'discovery.zen.ping.unicast.hosts' => ['es-01', 'es-02']
    },
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
    #net_host   => "0.0.0.0",
    es_version => '2.4.0'
  }
}
