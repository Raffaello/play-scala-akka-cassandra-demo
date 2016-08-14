### MOTD
class {'linux::base::motd' :
  content => '../motd.esb',
}

### timezone
class {'linux::base::timezone' :
  timezone => 'UTC',
}

### SELinux
# TODO config later...
class {'linux::security::selinux' :
  mode => permissive,
}