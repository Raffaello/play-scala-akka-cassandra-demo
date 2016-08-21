define pathmunge(
  $path=$title
  ) {
  validate_absolute_path($path)
  $array_path = split($path, "/") 
  validate_array($array_path)
  $munge_file = join($array_path, "_")
  if ( $osfamily == 'Debian' ) {
    if ! defined_with_params(File['/etc/profile.d/pathmunge.sh'], {'ensure' => 'present' }) {
      file { '/etc/profile.d/pathmunge.sh':
        ensure => present,
        owner  => '0',
        group  => '0',
        mode   => '0644',
        source => "puppet:///modules/pathmunge/pathmunge.sh",
      }
    }
  } else {}
  if ( $osfamily =~ /(RedHat|Debian)/ ) and ( $path != 'UNSET' ) {
    if ! defined_with_params(File["/etc/profile.d/${munge_file}.sh"], {'ensure' => 'present' }) {
      file { "/etc/profile.d/pm${munge_file}.sh":
        ensure  => present,
        owner   => '0',
        group   => '0',
        mode    => '0644',
        content => "pathmunge $path\n",
      }
    }
  } else {}
}
