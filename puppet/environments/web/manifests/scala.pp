include java

java::oracle { 'jdk8' :
  ensure  => 'present',
  version => '8',
  java_se => 'jdk',
}

#unzip
package { 'unzip':
  ensure => present,
  before => Exec['Unpack activator']
}

#activator
#https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10.zip
#activator-minimal
#exec { 'activator installer':
#  command => 'curl https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10-minimal.zip  \
#  && '
#}
$install_path = '/usr/share'
$activator_version = '1.3.10'
$activator_file = '/tmp/activator.zip'
#$minimal = '-minimal'
notice("Installing activator version $activator_version")
exec { 'download activator':
  command => "/usr/bin/curl https://downloads.typesafe.com/typesafe-activator/${activator_version}/typesafe-activator-${activator_version}.zip > ${activator_file}",
  cwd => '/tmp',
  logoutput => true,
  before => Exec['Unpack activator'],
  timeout => 0
}
-> exec { 'Unpack activator' :
  unless => "/usr/bin/test ! -f ${activator_file}",
  command     => "/usr/bin/unzip -o ${activator_file} -d ${install_path}",
  cwd         => '/tmp',
  user => root,
  logoutput => true,
  timeout => 0
}
-> file { "${install_path}/activator-dist-${activator_version}/bin/activator":
  ensure => 'present',
  mode => '0755',
  owner => 'vagrant',
  group => 'vagrant'
}
-> pathmunge { "${install_path}/activator-dist-${activator_version}/bin": }


#sbt
## curl https://bintray.com/sbt/rpm/rpm > bintray-sbt-rpm.repo
## sudo mv bintray-sbt-rpm.repo /etc/yum.repos.d/
## sudo yum install sbt
exec { 'sbt installer':
  command => '/usr/bin/curl https://bintray.com/sbt/rpm/rpm > bintray-sbt-rpm.repo && \
  mv bintray-sbt-rpm.repo /etc/yum.repos.d/ && \
  /usr/bin/yum install -y sbt',
  cwd => '/tmp',
  user => root,
  timeout => 0
}

#scala
#http://www.scala-lang.org/download
#http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz
$scala_version='2.11.8'
$scala_file = '/tmp/scala.tgz'
exec { 'scala installer' :
  command => "/usr/bin/curl http://downloads.lightbend.com/scala/2.11.8/scala-${scala_version}.tgz > ${scala_file}",
  cwd => '/tmp'
}
-> exec{ 'unpack scala':
  command => "/usr/bin/tar zxvf ${scala_file} -C ${install_path}",
  cwd => '/tmp',
  user => root,
  unless => "/usr/bin/test ! -f ${scala_file}"
}
-> file { "${install_path}/scala-${scala_version}":
  ensure => 'present',
  mode => '0755',
  owner => 'vagrant',
  group => 'vagrant',
  recurse => true
}
-> pathmunge { "${install_path}/scala-${scala_version}/bin": }