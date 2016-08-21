#
# == Class: linux::base::resolv_conf
#
# This class update /etc/resolv.conf to your
# default config.
#
class linux::base::resolv_conf (
  $nameservers = undef,
  $domainname  = undef,
  $searchpath  = [],
  $options     = undef,
  $template    = undef,
) inherits linux {

  if $template == undef {

    validate_array( $nameservers )

    if $domainname == undef and $searchpath == [] {
      $domainname_real = $::domain
    } elsif $domainname != undef and $searchpath == [] {
      $domainname_real = $::domain
    } elsif $domainname != undef and $searchpath != [] {
      fail('domainname and searchpath are mutually exclusive parameters')
    }

    file { 'resolv.conf':
      ensure  => file,
      path    => $linux::params::gb_rc_config_file,
      owner   => 'root',
      group   => $linux::params::gb_rc_group,
      mode    => '0644',
      content => template('linux/base/resolv_conf/resolv.conf.erb'),
    }
  }
  else {
    notice("#> Using template [${template}]")
    $domainname_real = $::domain

    file { 'resolv.conf':
      ensure  => file,
      path    => $linux::params::gb_rc_config_file,
      owner   => 'root',
      group   => $linux::params::gb_rc_group,
      mode    => '0644',
      content => template($template),
    }
  }
}
