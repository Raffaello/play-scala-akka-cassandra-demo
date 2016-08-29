#exec { 'yum upgrade':
#  command => '/usr/bin/yum -y upgrade',
#  cwd => '/usr/bin',
#  path => '/usr/bin',
#  logoutput => true,
#  timeout => 0
#}
#-> exec { 'reboot':
#  command => '/usr/sbin/reboot',
#  cwd => '/usr/sbin',
#  path => '/usr/sbin',
#  timeout => 0,
#  unless => "LAST_KERNEL=$(rpm -q --last kernel | perl -pe 's/^kernel-(\\S+).*/\$1/' | head -1); \
#   CURRENT_KERNEL=$(uname -r); \
#   /usr/bin/test \$LAST_KERNEL = \$CURRENT_KERNEL",
#  logoutput => true
#}

package {'unzip':
  ensure => present
}

### SWAP FILE
swap_file::files { 'default':
  ensure => absent
}

#reboot { 'after':
#  subscribe       => Exec['yum upgrade']
#}
