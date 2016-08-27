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



### ES

