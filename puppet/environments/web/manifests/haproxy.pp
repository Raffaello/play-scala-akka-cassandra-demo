class { 'haproxy':
  #global_options => {},
  #defaults_options => {}
}

haproxy::listen { 'web-haproxy':
  ipaddress => $::ipaddress,
  ports     => '8140'
}

haproxy::balancermember { $fqdn:
  listening_service => 'web-haproxy',
  server_names      => $::hostname,
  ipaddresses       => $::ipaddress,
  ports             => '8140',
  options           => 'check'
}