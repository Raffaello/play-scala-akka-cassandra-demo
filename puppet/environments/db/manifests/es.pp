class esNode {

}

node /^es-\d+$/ {
  include defaultNode
  include javaNode
  include esNode

  package { 'wget':
    ensure => present
  }

  $config_hash = {
    'ES_HEAP_SIZE' => '128M',
    'ES_MAX_HEAP_SIZE' => '128M'
  }

  class { 'elasticsearch':
    java_install      => false,
    package_url => 'https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.3.5/elasticsearch-2.3.5.rpm',
#    manage_repo       => false,
#    repo_version      => '2.3.5',
    restart_on_change => true,
    autoupgrade       => true,
    require => Package['wget'],
    init_defaults => $config_hash,
    config => {
      'cluster.name' => 'TitanDB Index',
      'network.host' => $::ipaddress
    }
  }

  elasticsearch::instance { $hostname: }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    instances => $hostname
  }
}
