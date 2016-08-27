class { 'docker':
  version => '1.12.1'
}

#docker::image { 'alpine': image_tag => 3.4 }

docker::image { 'uifd/ui-for-docker':
  image_tag => latest
}
##docker run -d -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker
docker::run { 'docker-ui':
  privileged => true,
  image => 'uifd/ui-for-docker',
  volumes => "/var/run/docker.sock:/var/run/docker.sock",
  ports => '9000:9000',
  name => 'docker-ui',
  require => Docker::Image[ 'uifd/ui-for-docker' ],
  remove_container_on_stop  => false,
}

# docker run --name some-cassandra -d cassandra:tag
docker::image { 'cassandra': image_tag => 3.7 }

docker::run { 'cassandra-1':
  image => 'cassandra:3.7',
  name => 'cassandra-1',
  require => Docker::Image[ 'cassandra'],
  remove_container_on_stop  => false
#  tag => 3.7
}

##docker run --name some-cassandra2 -d --link some-cassandra:cassandra cassandra:tag
#docker run --name cassandra-2 -d --link cassandra-1 cassandra:3.7
-> docker::run { 'cassandra-2':
  image => 'cassandra:3.7',
  links => ['cassandra-1'],
  name => 'cassandra-2',
  require => Docker::Image[ 'cassandra'],
  remove_container_on_stop  => false
#  tag => 'cassandra:3.7'
}

# docker run --name some-cassandra2 -d -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' some-cassandra)" cassandra:tag
# docker run --name some-cassandra2 -d --link some-cassandra:cassandra cassandra:tag
