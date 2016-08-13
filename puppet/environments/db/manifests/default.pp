class { 'docker':
    version => '1.12.0'
}

#docker::image { 'centos': image_tag => 7 }

#docker::run { 'helloworld':
#  image   => 'ubuntu',
#  command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
#}

#docker::image { 'cassandra': image_tag => 3.7 }
#docker::run { 'cassandra-1':
#  image => 'cassandra',
#  links =>
#}

