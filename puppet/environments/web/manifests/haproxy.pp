class haproxyNode {
  class { 'haproxy':
    global_options => {
      'log' => '127.0.0.1',
    },
#    defaults_options => {
#      'mode' => 'http'
#    },
    merge_options => true
  }

  haproxy::listen { 'web-haproxy':
    ipaddress => $::ipaddress_eth1,
    ports     => ['80'],
    bind => $::ipaddress_eth1,
    mode => 'http',
    options => ['httplog','dontlognull']
  }

  haproxy::balancermember { $fqdn:
    listening_service => 'web-haproxy',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress_eth1,
    ports             => '8140',
    options           => 'check'
  }
}
