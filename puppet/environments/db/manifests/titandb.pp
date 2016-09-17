class titanNode {
  include defaultNode
  include javaNode

  #include '::archive'
  $curl = '/usr/bin/curl'
  $titanDbVer = '1.0.0'
  $titanPath = "titan-${titanDbVer}-hadoop1"
  $titanZipFile = "${titanPath}.zip"
  $titanInstallDir = "/usr/share"

  #archive { "/tmp/${titanZipFile}":
  #  ensure => present,
  #  extract => true,
  #  extract_path => '/tmp',
  #  source => "http://s3.thinkaurelius.com/downloads/titan/titan-${titanDbVer}-hadoop1.zip",
  #  cleanup => true,
  #
  #}

  notice("Installing TitanDB version ${titanDbVer}")
  exec { 'titandb installer' :
    command   => "${curl} http://s3.thinkaurelius.com/downloads/titan/$titanZipFile > $titanZipFile",
    cwd       => '/tmp',
    unless    => "/usr/bin/test -f /tmp/${titanZipFile}",
    path      => '/usr/bin',
    logoutput => true,
    timeout   => 0,
    require => Package['unzip']
  }
  -> exec{ 'unpack titandb':
    command => "/usr/bin/unzip -o /tmp/${titanZipFile} -d ${titanInstallDir}",
    cwd     => '/tmp',
    user    => root,
    unless  => "/usr/bin/test  -f ${titanInstallDir}/bin/titan.sh",
    require => Exec['titandb installer'],
    timeout => 0
  }
  -> file { "${titanInstallDir}/${titanPath}/bin/titan.sh":
    ensure  => 'present',
    mode    => '0755',
    owner   => 'vagrant',
    group   => 'vagrant',
    recurse => true
  }
  -> pathmunge { "${titanInstallDir}/${titanPath}/bin": }

  file_line { "gremlin titan-cassandra-es.properties":
    require => Exec['unpack titandb'],
    path => "${titanInstallDir}/${titanPath}/conf/gremlin-server/gremlin-server.yaml",
    line => '  graph: conf/gremlin-server/titan-cassandra-es-server.properties}',
    match => '  graph: conf/gremlin-server/titan-berkeleyje-server.properties}'
  }

  # improvement for later: https://docs.puppet.com/guides/augeas.html
  file_line { "t-c-e.p 1":
    path  => "${titanInstallDir}/${titanPath}/conf/titan-cassandra-es.properties",
    line  => 'storage.hostname=10.10.30.11',
    match => 'storage.hostname=127.0.0.1'
  }
  file_line {"t-c-e.p 2":
    path => "${titanInstallDir}/${titanPath}/conf/titan-cassandra-es.properties",
    line => 'index.search.hostname=10.10.20.11, 10.10.20.12',
    match => 'index.search.hostname=127.0.0.1'
  }

}

node /^titandb-0(\d+)$/
{
  include osNode
  include titanNode
}