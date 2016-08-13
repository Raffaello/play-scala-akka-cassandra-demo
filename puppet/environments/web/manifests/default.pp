exec { "echo 'hello world!!!!'": path => "/usr/bin" }

#include 'docker'

class { 'docker':
    version => '1.12.0'
}

docker::image { 'centos': image_tag => 7 }

docker::run { 'helloworld': 
   image => 'centos',
   command => '/bin/sh -c "echo hello world"'
}