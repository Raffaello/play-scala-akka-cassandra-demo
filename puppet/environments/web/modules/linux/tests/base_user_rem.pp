# Test - base/user : Remove user from system
include linux
linux::base::user {'marco.braga':
  ensure => absent
}
