# Test base/user : Add user
include linux
linux::base::user {'marco.braga':
  ensure           => present,
  user             => 'marco.braga',
  comment          => 'Test add user',
  home             => '/home/marco.braga',
  password         => 'teste',
  gid              => 'marco.braga',
  groups           => ['users','g2'],
  shell            => '/bin/bash',
  manage_home      => true,
  password_max_age => '99999',
  password_min_age => '0',
  group_ensure     => 'present'
}
