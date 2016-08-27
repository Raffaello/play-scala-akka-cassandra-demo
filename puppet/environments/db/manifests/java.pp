package {'java-1.7.0-openjdk':
  ensure => absent,
  before => Class['java']
}
package {'java-1.8.0-openjdk':
  ensure => absent,
  before => Class['java']
}
->
class { 'java':
#  distribution => 'oracle-jdk',
  java_alternative => 'java',
  java_alternative_path => '/usr/java/jdk1.8.0_51/jre/bin/java'
}

java::oracle { 'jdk8' :
  ensure  => 'present',
  version => '8',
  java_se => 'jdk',
  before => Class['java']
}

package { 'jna':
  ensure => present,
#  before => Class['cassandra']
}



