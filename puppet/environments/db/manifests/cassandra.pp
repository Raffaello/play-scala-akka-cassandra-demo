class { 'cassandra::datastax_repo':
	before => Class['cassandra']
}
-> class { 'cassandra':
	authenticator		 => 'PasswordAuthenticator',
	cluster_name 		=> 'cassandra_cluster',
	dc			=> 'DC1',
	endpoint_snitch		=> 'GossipingPropertyFileSnitch',
	#listen_interface 	=> "eth0",
	num_tokens		=> 256,
	#seeds			=> 110.82.155.0
	listen_address		=> "${::ipaddress}",
	seeds			=> "${::ipaddress}",
	auto_bootstrap		=> false,
	require => Class['cassandra::datastax_repo', 'java']
}
#-> class { 'cassandra::schema':
#  cqlsh_password => 'cassandra',
#  cqlsh_user     => 'cassandra',
#}
-> class { 'cassandra::datastax_agent':
  stomp_interface => "${::ipaddress}"
}
-> class { '::cassandra::opscenter': }

