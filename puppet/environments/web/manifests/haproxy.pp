class haproxyNode {
  class { 'haproxy':
    service_ensure => true,
    global_options => {
      'log' => '127.0.0.1',
      'maxconn' => 10
    },
#    defaults_options => {
#      'mode' => 'http'
#    },
    merge_options => true
  }

  haproxy::listen { 'web-haproxy':
    ipaddress => $::ipaddress_eth1,
    ports     => '81',
    mode => 'http',
    options => {
      'option' => ['httplog','dontlognull'],
      'balance' => 'roundrobin'
    }
  }

  haproxy::balancermember { 'playwebserver01':
    listening_service => 'web-haproxy',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress_eth1,
    ports             => '8080',
    options           => 'check'
  }

  haproxy::balancermember { 'playwebserver02':
    listening_service => 'web-haproxy',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress_eth1,
    ports             => '9080',
    options           => 'check'
  }

  haproxy::frontend { 'http-in':
    ipaddress => $::ipaddress_eth1,
    ports => '80',
    mode => 'http',
#    bind_options => 'accept-proxy',
    options => {
      'default_backend' => 'play_webserver',
      'timeout client' => '10s',
      'option' => ['httplog', 'dontlognull']
    }
  }

  haproxy::backend { 'play_webserver':
    collect_exported => false,
    options => {
      'option'  => [
        'httplog'
      ],
      'balance' => 'roundrobin'
    }
  }
}
