#class { 'haproxy': }
#haproxy::listen { 'web-haproxy':
#  ipaddress => $::ipaddress,
#  ports     => '8140',
#}
