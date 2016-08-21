#
# == Class: linux::base::hosts
#
# This module manages the /etc/hosts file.
#
class linux::base::hosts {
  host { $::fqdn:
    ip           => $::ipaddress,
    host_aliases => [ $::hostname ],
  }
}
