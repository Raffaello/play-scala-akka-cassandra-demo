exec { 'yum upgrade':
  command => '/usr/bin/yum -y upgrade',
  cwd => '/usr/bin',
  path => '/usr/bin',
  logoutput => true,
  timeout => 0
}

exec { 'unzip':
  command => '/usr/bin/yum install -y unzip',
  timeout => 0
}




