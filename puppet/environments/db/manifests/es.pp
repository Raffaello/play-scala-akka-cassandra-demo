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
  class {'linux::security::selinux' :
    mode => permissive
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
    }
  }
#  elasticsearch::instance { $hostname: }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf/v2.1.1':
    ensure => present
  }
}

node /^es-\d+$/
{
  include osNode

  class { 'esNode':
    net_host   => "10.10.20.1$1",
    es_version => '2.4.0'
  }
}
