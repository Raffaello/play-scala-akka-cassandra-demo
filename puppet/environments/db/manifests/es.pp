node /^es-\d+$/ {
  include defaultNode
  include javaNode
  #include esNode

  package { 'wget':
    ensure => present
  }

  $config_hash = {
    'ES_HEAP_SIZE' => '128M',
    'ES_MAX_HEAP_SIZE' => '128M'
  }

  $es_version = '2.4.0'
  class { 'elasticsearch':
    java_install      => false,
    package_url => "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/$es_version/elasticsearch-$es_version.rpm",
#    manage_repo       => false,
#    repo_version      => '2.3.5',
    restart_on_change => true,
    autoupgrade       => true,
    require => Package['wget'],
    init_defaults => $config_hash,
    config => {
      'cluster.name' => 'TitanDB_Index',
      'network.host' => $::ipaddress
    }
  }

  elasticsearch::instance { $hostname: }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    instances => $hostname
  }
}
