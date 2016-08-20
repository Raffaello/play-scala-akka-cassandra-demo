class { 'cassandra::datastax_repo':
	before => Class['cassandra']
}
-> class {'cassandra::java':
  before => Class['cassandra']
}
-> class { 'cassandra':
	#authenticator		 => 'PasswordAuthenticator',
	cluster_name 		=> 'cassandra_cluster',
	dc			=> 'DC1',
	endpoint_snitch		=> 'GossipingPropertyFileSnitch',
	#listen_interface 	=> "eth0",
	num_tokens		=> 256,
	#seeds			=> 110.82.155.0
	listen_address		=> "${::ipaddress}",
	seeds			=> "${::ipaddress}",
	auto_bootstrap		=> false,
	require => Class['cassandra::datastax_repo', 'java'],
	concurrent_reads => 8,
  concurrent_writes => 8,
  concurrent_counter_writes => 8,
  file_cache_size_in_mb => 8,
  memtable_heap_space_in_mb => 32,
  memtable_offheap_space_in_mb => 24
}
#-> class { 'cassandra::schema':
#  users => { 'cassandra' => { password => 'cassandra'}},
#  #cqlsh_password => 'cassandra',
#  #cqlsh_user     => 'cassandra',
#}
#-> class { 'cassandra::datastax_agent':
#  stomp_interface => "${::ipaddress}"
#}
#-> class { '::cassandra::opscenter': }
#

class { 'cassandra::env':
  file_lines => {
    'MAX_HEAP_SIZE' => {
      line  => 'MAX_HEAP_SIZE="64M"',
      match => '#MAX_HEAP_SIZE="4G"',
    },
    'HEAP_NEWSIZE'  => {
      line  => "HEAP_NEWSIZE='32M'",
      match => '#HEAP_NEWSIZE="800M"',
    },
    'JVM_OPTS server.hostname' => {
      line => 'JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=127.0.0.1',
      match => 'JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=<public name>'
    }
  }
}