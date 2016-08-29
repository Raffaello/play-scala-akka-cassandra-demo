class esNode {
  $config_hash = {
    'ES_HEAP_SIZE' => '128M',
    'ES_MAX_HEAP_SIZE' => '128M'
  }
}

node /^es-\d+$/ {
  include javaNode
  include esNode

  class { 'elasticsearch':
    java_install      => false,
    package_url => 'https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.3.5/elasticsearch-2.3.5.rpm',
    manage_repo       => true,
    repo_version      => '2.3.5',
    restart_on_change => true,
    autoupgrade       => true,

  }

  elasticsearch::instance { $hostname: }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    instances => $hostname
  }
}
