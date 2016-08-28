# docker run --name some-cassandra -d cassandra:tag
docker::image { 'cassandra': image_tag => 3.7 }

docker::run { 'cassandra-1':
  image => 'cassandra:3.7',
  name => 'cassandra-1',
  require => Docker::Image[ 'cassandra'],
  remove_container_on_stop  => false,
  hostname => 'db.dev.cassandra-1'
  #  tag => 3.7
}

  ##docker run --name some-cassandra2 -d --link some-cassandra:cassandra cassandra:tag
  #docker run --name cassandra-2 -d --link cassandra-1 cassandra:3.7
-> docker::run { 'cassandra-2':
  image => 'cassandra:3.7',
  links => ['cassandra-1'],
  name => 'cassandra-2',
  require => Docker::Image[ 'cassandra'],
  remove_container_on_stop  => false,
  hostname => 'db.dev.cassandra-2'
  #  tag => 'cassandra:3.7'
}
-> docker::run { 'cassandra-3':
  image => 'cassandra:3.7',
  links => ['cassandra-1'],
  name => 'cassandra-3',
  require => Docker::Image[ 'cassandra'],
  remove_container_on_stop  => false,
  hostname => 'db.dev.cassandra-3'
  #  tag => 'cassandra:3.7'
}