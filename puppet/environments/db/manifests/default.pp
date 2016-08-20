#class { 'docker':
#  version => '1.12.0'
#}

#docker::image { 'centos': image_tag => 7 }
##docker run -d -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker
#docker::run { 'docker-ui':
#  privileged => true,
#  image => 'centos',
#  volumes => "/var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker",
#  ports => '9000:9000'
#}

#docker::image { 'cassandra': image_tag => 3.7 }
#docker::run { 'cassandra-1':
#  image => 'cassandra',
#  tag => 3.7
#}
#
##docker run --name some-cassandra2 -d --link some-cassandra:cassandra cassandra:tag
#docker::run { 'cassandra-2':
#  image => 'cassandra',
#  links => 'cassandata-1:cassandra',
#  tag => 3.7
#}



