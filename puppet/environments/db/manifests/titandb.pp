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
  command => "${curl} http://s3.thinkaurelius.com/downloads/titan/$titanZipFile > $titanZipFile",
  cwd => '/tmp',
  unless => "/usr/bin/test -f /tmp/${titanZipFile}",
  path => '/usr/bin',
  logoutput => true,
  timeout => 0
}
-> exec{ 'unpack titandb':
  command => "/usr/bin/unzip /tmp/${titanZipFile} -o -d ${titanInstallDir}",
  cwd => '/tmp',
  user => root,
  unless => "/usr/bin/test ! -f ${titanInstallDir}/bin/titan.sh",
  require => Exec['titandb installer'],
  timeout => 0
}
-> file { "${titanInstallDir}/${titanInstallDir}/${titanPath}":
  ensure => 'present',
  mode => '0755',
  owner => 'vagrant',
  group => 'vagrant',
  recurse => true
}
-> pathmunge { "${titanInstallDir}/${titanPath}/bin": }
