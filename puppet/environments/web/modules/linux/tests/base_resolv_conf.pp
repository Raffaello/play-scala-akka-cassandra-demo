# Example of class: RESOLV_CONF
class { 'linux::base::resolv_conf' :
  template => 'linux/base/resolv_conf/resolv.conf-test.erb',
}
