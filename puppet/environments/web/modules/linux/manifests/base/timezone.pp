#
# == Class: linux::base::timezone
#
# This module manages timezone settings
#
# Actions:
#   Installs tzdata and configures timezone
#
# Sample Usage:
#   class { 'timezone':
#     timezone => 'America/Sao_Paulo',
#   }
#
class linux::base::timezone (
  $ensure       = 'present',
  $timezone     = undef,
  $autoupgrade  = false,
) inherits linux {

  validate_bool($autoupgrade)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }
      $localtime_ensure = 'link'
      $timezone_ensure  = 'file'
    }
    /(absent)/: {
      # Leave package installed, as it is a system dependency
      $package_ensure   = 'present'
      $localtime_ensure = 'absent'
      $timezone_ensure  = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { $linux::params::gb_tz_package:
    ensure => $package_ensure,
  }

  if $linux::params::gb_tz_timezone_file != false {
    file { $linux::params::gb_tz_timezone_file:
      ensure  => $timezone_ensure,
      content => template($linux::params::gb_tz_timezone_file_template),
    }
  }

  file { $linux::params::gb_tz_localtime_file:
    ensure  => $localtime_ensure,
    target  => "${linux::params::gb_tz_zoneinfo_dir}${timezone}",
    require => Package[$linux::params::gb_tz_package],
  }
}
