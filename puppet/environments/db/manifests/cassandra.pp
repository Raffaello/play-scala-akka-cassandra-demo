class cassandraNode {
  include defaultNode
  #include noSwapNode
  ### the agents (datastax,..) make needs more memory, so swap needed
  exec {'swappines':
    command => '/sbin/sysctl vm.swappiness=10'
  }

  include javaNode

  package { 'jemalloc':
    ensure => present
  }

  class { 'cassandra::datastax_repo':
    pkg_url => 'http://rpm.datastax.com/datastax-ddc/3.7',
  }
  -> class { 'cassandra':
    service_ensure => running,
    authenticator		 => 'PasswordAuthenticator',
    cluster_name 		=> 'cassandra_cluster',
    dc			=> 'DC1',
    endpoint_snitch		=> 'GossipingPropertyFileSnitch',
    listen_interface 	=> "eth1",
    num_tokens		=> 4,
    seeds			=> "10.10.30.11",
    listen_address		=> "${::ipaddress_eth1}",
    auto_bootstrap		=> false,
    require => Class['cassandra::datastax_repo', 'java'],
    concurrent_reads => 2,
    concurrent_writes => 2,
    concurrent_counter_writes => 2,
    file_cache_size_in_mb => 4,
    memtable_heap_space_in_mb => 4,
    memtable_offheap_space_in_mb => 2,
    package_name => 'datastax-ddc',
    rpc_server_type => 'sync',
    rpc_min_threads => 1,
    rpc_max_threads => 1,
    concurrent_compactors => 1,
    compaction_throughput_mb_per_sec => 0,
    key_cache_size_in_mb => 1,
    commitlog_total_space_in_mb => 8,
    native_transport_max_frame_size_in_mb => 8,
    thrift_framed_transport_size_in_mb => 8,
#    row_cache_size_in_mb => 0
    commitlog_segment_size_in_mb => 8,
    hinted_handoff_enabled => false,
    hinted_handoff_throttle_in_kb => 0,
    max_hints_delivery_threads => 1,
#    hints_directory => "",
    memtable_flush_writers => 2,
    rpc_interface => 'eth1',
#    broadcast_address => $ipaddress_eth1
  }
  -> file {'/hints/':
    ensure => directory,
    mode => '0775',
    group => 'cassandra',
    owner => 'cassandra',
  }

  ### not working with cassandra 3.x (opscenter needed 6.x)
#  yumrepo { "datastax-community":
#    baseurl => "http://rpm.datastax.com/community",
#    descr => "datastax-community",
#    enabled => 1,
#    gpgcheck => 0
#  }
#  -> class { 'cassandra::datastax_agent':
#    stomp_interface => '10.10.10.10',
#  }

  $jmxRemotePw = 'jmxremote.password'
  $jmxRemoteAcc = 'jmxremote.access'
  $jmxPath = '/etc/cassandra'

  class { 'cassandra::file':
    file => 'cassandra-env.sh',
    file_lines => {
      'MAX_HEAP_SIZE' => {
        line  => 'MAX_HEAP_SIZE="64M"',
        match => '#MAX_HEAP_SIZE="4G"'
      },
      'HEAP_NEWSIZE'  => {
        line  => "HEAP_NEWSIZE='16M'",
        match => '#HEAP_NEWSIZE="800M"'
      },
      'NO LOCAL_JMX' => {
        line  => 'LOCAL_JMX=no',
        match => 'LOCAL_JMX=yes'
      },
      'JVM_OPTS server.hostname' => {
        line  => "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$ipaddress_eth1\"",
        match => 'JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=<public name>"',
      },
      'JVM_OPTS out of mem' => {
        line => 'JVM_OPTS="$JVM_OPTS -XX:+HeapDumpOnOutOfMemoryError"'
      },
      # there is a $CASSANDRA_HEAPDUMP_DIR var too...
      'JVM_OPTS crash log' => {
        line => 'JVM_OPTS="$JVM_OPTS -XX:HeapDumpPath=/var/log/cassandra/crash_`date +%s`.hprof"'
      },
      'JVM_OPTS remote.pw' => {
        match => '#JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.password.file=/etc/cassandra/jmxremote.password"',
        line  => "JVM_OPTS=\"\$JVM_OPTS -Dcom.sun.management.jmxremote.password.file=${jmxPath}/${jmxRemotePw}\""
      },
      'JVM_OPTS remote.access' => {
        match => '#JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.access.file=/etc/cassandra/jmxremote.access"',
        line  => "JVM_OPTS=\"\$JVM_OPTS -Dcom.sun.management.jmxremote.access.file=${jmxPath}/${jmxRemoteAcc}\""
      }
    }
  }

  $jmxRemotePwContent = 'monitorRole QED
controlRole R&D
cassandra cassandra'

  $jmxRemoteAccContent = 'monitorRole readonly
cassandra readwrite
controlRole readwrite \
unregister'

  file { $jmxRemotePw:
    path    => "$jmxPath/$jmxRemotePw",
    owner   => 'cassandra',
    group   => 'cassandra',
    ensure  => present,
    content => $jmxRemotePwContent,
    mode    => '0400',
#    source => 'puppet:///files/jmxremote.password'
  }
  file { $jmxRemoteAcc:
    path    => "$jmxPath/$jmxRemoteAcc",
    owner   => 'cassandra',
    group   => 'cassandra',
    ensure  => present,
    content => $jmxRemoteAccContent,
    mode    => '0400',
#    source => 'puppet:///files/jmxremote.access'
  }
}

node /^cassandra-0(\d+)$/
{
  include osNode
  include cassandraNode
  class { 'consulAgentNode':
    consulServerIp => '10.10.10.10'
  }
}

##-> class { 'cassandra::schema':
##  users => { 'cassandra' => { password => 'cassandra'}},
##  #cqlsh_password => 'cassandra',
##  #cqlsh_user     => 'cassandra',
##}
