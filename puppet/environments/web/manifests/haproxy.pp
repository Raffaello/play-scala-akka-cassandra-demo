class { 'haproxy':
  #global_options => {},
  #defaults_options => {}
}

haproxy::listen { 'web-haproxy':
  ipaddress => $::ipaddress,
  ports     => '8140',

}
