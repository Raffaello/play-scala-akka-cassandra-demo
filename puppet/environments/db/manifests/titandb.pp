#include '::archive'
$curl = '/usr/bin/curl'
$titanDbVer = '1.0.0'
$titanZipFile = "titan-${titanDbVer}-hadoop1.zip"
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
  command => "${curl} http://s3.thinkaurelius.com/downloads/titan/titan-${titanDbVer}-hadoop1.zip > $titanZipFile",
  cwd => '/tmp',
  #unless => 'which titan.sh',
  path => '/usr/bin'
}
-> exec{ 'unpack titandb':
  command => "/usr/bin/unzip /tmp/${titanZipFile} -C ${titanInstallDir}",
  cwd => '/tmp',
  user => root,
  unless => "/usr/bin/test ! -f /tmp/${titanZipFile}",
  require => Exec['titandb installer']
}
-> file { "${titanInstallDir}/titan-${titanInstallDir}":
  ensure => 'present',
  mode => '0755',
  owner => 'vagrant',
  group => 'vagrant',
  recurse => true
}
-> pathmunge { "${titanInstallDir}/titan-${titanDbVer}/bin": }
