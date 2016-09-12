class cassandraNode {
  include defaultNode
  #include noSwapNode
  include javaNode

  class { 'cassandra::datastax_repo':
    pkg_url => 'http://rpm.datastax.com/datastax-ddc/3.7',
  	before => Class['cassandra']
  }
  -> class { 'cassandra':
    #authenticator		 => 'PasswordAuthenticator',
    cluster_name 		=> 'cassandra_cluster',
    dc			=> 'DC1',
    endpoint_snitch		=> 'GossipingPropertyFileSnitch',
    listen_interface 	=> "eth1",
    num_tokens		=> 256,
    seeds			=> "10.10.30.11",
    #listen_address		=> "${::ipaddress}",
    auto_bootstrap		=> false,
    require => Class['cassandra::datastax_repo', 'java'],
    concurrent_reads => 2,
    concurrent_writes => 2,
    concurrent_counter_writes => 2,
    file_cache_size_in_mb => 2,
    memtable_heap_space_in_mb => 64,
    memtable_offheap_space_in_mb => 32,
    package_name => 'datastax-ddc'
  }
  class { 'cassandra::file':
    file_lines => {
      'MAX_HEAP_SIZE' => {
        line  => 'MAX_HEAP_SIZE="128M"',
        match => '#MAX_HEAP_SIZE="4G"',
      },
      'HEAP_NEWSIZE'  => {
        line  => "HEAP_NEWSIZE='128M'",
        match => '#HEAP_NEWSIZE="800M"',
      },
      'JVM_OPTS server.hostname' => {
        line => "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$ipaddress\"",
        match => 'JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=<public name>"'
      },
      'extra JVN_OPTS' => {
        line => 'JVM_OPTS="$JVM_OPTS -XX:+HeapDumpOnOutOfMemoryError"',
        line => 'JVM_OPTS="$JVM_OPTS -XX:HeapDumpPath=/var/crash/cassandra_`date +%s`.hprof"'
      }
    }
  }
}

node /^cassandra-0(\d+)$/
{
  include osNode
  include cassandraNode
}

##-> class { 'cassandra::schema':
##  users => { 'cassandra' => { password => 'cassandra'}},
##  #cqlsh_password => 'cassandra',
##  #cqlsh_user     => 'cassandra',
##}
##-> class { 'cassandra::datastax_agent':
##  stomp_interface => "${::ipaddress}"
##}
##-> class { '::cassandra::opscenter': }

