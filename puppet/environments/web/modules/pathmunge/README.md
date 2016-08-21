Puppet Pathmunge
=================
This is a simple puppet module that can add a system-wide path for all users. It is tested on CentOS 6.4 and Ubuntu 12.04 and should work on any RedHat or Debian type system.

###Example
```
  pathmunge { '/opt/some/path': }
  pathmunge { '/opt/some/other/path': }
```
###RESULT
```
  [panaman@server01 ~]$ echo $PATH
  /opt/some/path:/opt/some/other/path:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/panaman/bin
  [panaman@server01 ~]$
```
###Support
Please log tickets and issues at our [Projects site](https://github.com/panaman/puppet-pathmunge/issues)
