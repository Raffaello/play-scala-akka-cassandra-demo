exec { 'yum upgrade':
  command => '/usr/bin/yum -y upgrade',
  cwd => '/usr/bin',
  path => '/usr/bin',
  logoutput => true,
  timeout => 0
}

package {'unzip':
  ensure => present
}

### SWAP FILE
swap_file::files { 'default':
  ensure => absent
}


