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
#exec { 'activator installer':
#  command => 'curl https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10-minimal.zip  \
#  && '
#}
$activator_version = '1.3.10'
$activator_file = '/tmp/activator.zip'
notice("Installing activator version $activator_version")

exec { 'download activator':
  command => "/usr/bin/curl https://downloads.typesafe.com/typesafe-activator/${activator_version}/typesafe-activator-${activator_version}-minimal.zip > ${activator_file}",
  cwd => '/tmp',
  #logoutput => true,
  before => Exec['Unpack activator']
}
-> exec { 'Unpack activator' :
    unless => "/usr/bin/test ! -f ${activator_file}",
    command     => "/usr/bin/unzip -o ${activator_file} -d /opt/",
    cwd         => '/tmp',
    user => root,
    logoutput => true
}
-> file { "/opt/activator-${activator_version}-minimal/bin/activator":
  ensure => 'present',
  mode => '0755',
  owner => 'vagrant',
  group => 'vagrant'
}
-> pathmunge { "/opt/activator-${activator_version}-minimal/bin": }


#sbt
## curl https://bintray.com/sbt/rpm/rpm > bintray-sbt-rpm.repo
## sudo mv bintray-sbt-rpm.repo /etc/yum.repos.d/
## sudo yum install sbt
#exec { 'sbt installer':
#  command => 'curl https://bintray.com/sbt/rpm/rpm > bintray-sbt-rpm.repo && \
#  mv bintray-sbt-rpm.repo /etc/yum.repos.d/ && \
#  /usr/bin/yum install -y sbt'
#}

#scala
