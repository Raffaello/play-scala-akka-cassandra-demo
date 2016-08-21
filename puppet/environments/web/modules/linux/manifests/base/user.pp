#
# == Class: linux::base::user
#
# This function add/remove user from Linux System.
# Ensure can assume follow values:
# * present : add user
# * absent  : remove user
#
# When ensure is 'absent', function will kill user session and delete it.
#
define linux::base::user (
  $ensure           = 'present',
  $user             = $title,
  $comment          = 'User add by puppet',
  $home             = undef,
  $password         = '!',
  $gid              = undef,
  $groups           = [],
  $shell            = '/bin/bash',
  $manage_home      = true,
  $password_max_age = '99999',
  $password_min_age = '0',
  $group_ensure     = 'ignore'
) {

  if !$user {
    fail{"# User [${user}] not recognized.": fail => true }
  }
  
  if $group_ensure == 'present' {
    if $gid {
      group { $gid : ensure => present }
    }
    if $groups {
      group { [$groups] : ensure => present }
    }
  }

  # Check options
  if $home == undef { $usr_home = "/home/${user}" }
  else { $usr_home = $home }

  if $gid == undef { $usr_gid = $user }
  else { $usr_gid = $gid }

  case $ensure {
    # 'pre-remove' user : Kill current sessions
    'absent': {
      exec { "killing ${user}":
        command => "pkill -9 -u ${user}",
        path    => '/usr/bin',
        onlyif  => "grep '^${user}' /etc/passwd && ps -u ${user}",
        before  => User[$user];
      }
      # removing user
      user { $user:
        ensure     => $ensure,
      }
    }
    'present': {
      user { $user:
        ensure           => $ensure,
        comment          => $comment,
        name             => $user,
        home             => $usr_home,
        password         => $password,
        groups           => $groups,
        gid              => $usr_gid,
        shell            => $shell,
        managehome       => $manage_home,
        password_max_age => $password_max_age,
        password_min_age => $password_min_age,
      }
    }
    default: {
      warning{"# Option [${ensure}] not found.": }
    }
  }
}
