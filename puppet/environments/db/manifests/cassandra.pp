class { 'cassandra::datastax_repo':
	before => Class['cassandra']
}

class { 'cassandra': 
	#authenticator		 => 'auth',
	cluster_name 		=> 'cassandra_cluster',
	dc			=> 'DC1',
	endpoint_snitch		=> 'GossipingPropertyFileSnitch',
	listen_interface 	=> "eth0",
	num_tokens		=> 256,
	#seeds			=> 110.82.155.0
	listen_address		=> $::ipaddress,
	seeds			=> $::ipaddress,
	auto_bootstrap		=> false
	}

