include java

java::oracle { 'jdk8' :
  ensure  => 'present',
  version => '8',
  java_se => 'jdk',
  before => Class['cassandra']
}


class { 'docker':
    version => '1.12.0'
}

docker::image { 'centos': image_tag => 7 }

docker::run { 'helloworld': 
   image => 'centos',
   command => '/bin/sh -c "echo hello world"'
}

