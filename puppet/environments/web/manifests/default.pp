#export FACTER_DIST=true
#if $::dist = true {
#
#} else {
#
#}

#class { 'docker':
#    version => '1.12.0'
#}

#docker::image { 'alpine': image_tag => 3.4 }
#
#docker::run { 'helloworld':
#   image => '',
#   command => '/bin/sh -c "echo hello world"'
#}

### build
#$home = '/home/vagrant'
#exec { 'sbt dist':
#  command => "${install_path}/activator dist",
#  cwd => '/home/vagrant/play-scala-akka-cassandra-demo/target/universal/',
#
#  onlyif => '! test -f ',
#  noop => Notify['building dist packages...']
#}
