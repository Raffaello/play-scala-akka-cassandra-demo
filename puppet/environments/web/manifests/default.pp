#export FACTER_DIST=true
#if $::dist = true {
#
#} else {
#
#}
#
#exec { 'yum upgrade':
#  command => '/usr/bin/yum -y upgrade',
#  cwd => '/usr/bin',
#  path => '/usr/bin',
#  logoutput => true,
#  timeout => 0
#}
#-> exec { 'reboot':
#  command => '/usr/bin/reboot',
#  cwd => '/usr/bin',
#  path => '/usr/bin',
#  timeout => 0,
#  unless => 'LAST_KERNEL=$(rpm -q --last kernel | perl -pe \'s/^kernel-(\S+).*/$1/\' | head -1); \
#   CURRENT_KERNEL=$(uname -r); \
#   /usr/bin/test $LAST_KERNEL = $CURRENT_KERNEL || /usr/sbin/reboot',
#  logoutput => true
#}


#reboot { 'after':
#  subscribe       => Exec['yum upgrade']
#}

#class { 'docker':
#    version => '1.12.1'
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
