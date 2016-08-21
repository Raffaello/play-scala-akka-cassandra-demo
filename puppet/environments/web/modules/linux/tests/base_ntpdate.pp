# Example of class: NTPdate
class { 'linux::base::ntpdate' :
  ntpserver => 'pool.ntp.br',
}
