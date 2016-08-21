#
# == Class: linux::security::selinux
#
# This module manages the SELinux configuration file.
#
class linux::security::selinux (
  $mode          = 'permissive',
  $type          = 'targeted',
  $setlocaldefs  = undef,
  $config_file   = '/etc/selinux/config',
  $template_conf = undef,
) {

  ## Check 
  validate_re($mode,
    '^enforcing|permissive|disabled$',
    "Mode [${mode}] must be either 'enforcing', 'permissive' or 'disabled'.")

  validate_re($type,
    '^targeted|strict$',
    "type is ${type} and must be either 'targeted' or 'strict'.")

  if $setlocaldefs != undef {
    validate_re($setlocaldefs,
      '^0|1$',
      "local defs is ${setlocaldefs} must be either 0 or 1.")
  }

  validate_absolute_path($config_file)

  if $template_conf == undef {
    $template = 'linux/security/selinux/config.erb'
  } else {
    $template = $template_conf
  }

  ## Set mode
  if $mode == 'disabled' {
    exec { 'disable_selinux':
      command => '/usr/sbin/setenforce 0',
      onlyif  => '/usr/sbin/selinuxenabled',
    }
  }

  ## Save config
  file { 'selinux_config':
    ensure  => 'file',
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($template),
  }
}
