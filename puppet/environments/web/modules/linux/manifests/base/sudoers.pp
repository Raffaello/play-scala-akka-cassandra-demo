#
# == Class: linux::base::sudoers
#
# This class manage /etc/sudoers file.
#
class linux::base::sudoers (
  $template    = 'linux/base/sudoers/sudoers',
) inherits linux {

  # Update sudoers file
  file { '/etc/sudoers':
    ensure  => file,
    path    => '/etc/sudoers',
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template($template),
  }

}
