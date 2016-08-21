# Linux

#### Table of Contents

1. [Overview](#1-overview)
2. [Module Description](#2-module-description)
3. [Setup](#3-setup)
    * [What module affects](#what-module-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning](#beginning)
4. [Usage](#4-usage)
5. [Reference](#5-reference)
6. [Limitations](#6-limitations)
7. [Development](#7-development)
8. [Release Notes](#8-release-notes)

## 1. Overview

This module is a 'all-in-one' module to manage main Linux configurations including basic and security options

## 2. Module Description

This module is a 'all-in-one' module to manage main Linux configurations, that includes:

Security administration:
* SELinux config
 
Basic Sysadmin administration:
* motd
* ntpdate
* hosts
* timezone
* resolv.conf
* sudoers


## 3. Setup

### What module affects

* This module can change all the behavior of the Linux Operational System,
  mostly the security classes
  

### Setup Requirements 

Install module:
* puppet module install mtulio-linux

### Beginning

This is a great module to configure your OS Linux. This module can be called from a 
profile module, and it was created to be easy to manage the simple Linux configurations.

## 4. Usage

Check usage of each class: 


### Base Class: NTPdate

* Schedulle at contab an ntpdate execution using custom ntp servers:

```
 class {'linux::base::ntpdate' :
   ntpserver => 'pool.ntp.br',
 }
```

### Base Class: MOTD

* Create a default 'Message of the Day':

```
 class {'linux::base::motd' : }
```

* Create a custom message:

```
 class {'linux::base::motd' : 
   content => 'Custom motd message',
 }
```

* Create a custom esb template file:

```
 class {'linux::base::motd' :
   content => 'custom/path/to/motd.esb',
 }
```

### Base Class: HOSTS

* Update hots file:

```
 class {'linux::base::hosts' : }
```

### Base Class: TIMEZONE

* Update system timezone, using default timezone [linux::params]:

```
 class {'linux::base::timezone' : }
```

* Update system timezone from system, usgin custom timezone:

```
 class {'linux::base::timezone' : 
   timezone => 'America/Recife',
 }
```

### Base Class: RESOLV_CONF

* Update /etc/resolv.conf from [linux::params]:

```
 class {'linux::base::resolv_conf' : }
```

* Update /etc/resolv.conf of custom servers:

```
 class {'linux::base::resolv_conf' : 
   nameservers = ['8.8.8.8'],
 }
```

### Base Class: SUDOERS

* Update /etc/sudoers from default template :

```
 class {'linux::base::resolv_conf' : }
```

* Update /etc/sudoers from custom template:

```
 class {'linux::base::resolv_conf' : 
   template => '/path/to/your/template/sudoers',
 }
```

### Base Function: USER

* Add local user [tests/base_user_add.pp]:

```
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
```

* Remove user from system [tests/base_user_rem.pp]:
```
include linux
linux::base::user {'marco.braga':
  ensure => absent
}
```


### Security Class: SELinux

* Set to permissive mode:

```
 class {'linux::security::selinux' :
   mode => permissive,
 }
```

* Set to enforced mode:

```
class {'linux::security::selinux' :
  mode => enforced,
}
```

* Set to 'disabled' mode:

```
 class {'linux::security::selinux' :
   mode => disabled,
 }
```

* Config from your own custom template:

```
 class {'linux::security::selinux' :
   template_conf => 'module/selinux/config.erb',
 }
```


## 5. Reference

### Base Class: NTPdate

* Description: Schedulle to update System Time using ntpdate
* Default ntp server: 'a.ntp.br'
* Files affected: 

```
/etc/crontab
```

### Base Class: MOTD

* Description: Create a custom 'Message of the Day'
* Files affected: 

```
 /etc/motd
```

### Base Class: Hosts

* Description: Update hosts file with your local IP address and domain
* Files affected: 

```
/etc/hosts
```

### Base Class: TIMEZONE

* Description: Update system timezone
* Files affected: 

```
/etc/localtime
/etc/timezone
```

### Base Class: RESOLV_CONF

* Description: Update DNS local resolver configuration
* Files affected: 

```
/etc/resolv.conf
```
### Base Class: SUDOERS

* Description: Update SUDOERS file to manage grant right for users on Linux System
* Files affected: 

```
/etc/sudoers
```
### Feature User: Base/USER

* Description: Add or remove local users on Linux System
* Files affected: 

```
/etc/passwd
/etc/shadow
/etc/groups
```

### Security Class: SELinux

* Description: Configure SELinux to enforcing, permissive or disabled mode
* Files affected: 

```
/etc/selinux/config
```

## 6. Limitations

OS compatibility: 
* Red Hat family 7+ 

We're working to support more OS.

## 7. Development

See project page at https://github.com/mtulio/puppet-linux

## 8. Release Notes

[1.1.1]
* Fix metadata dependences

[1.1.0]
* New feature: 'linux::base::user' - Manage and delete users

[1.0.1] - [1.0.3]
* Documentation review and fix
* Coding style review

[1.0.0]
* Add module: linux::base::sudoers
* Review documentation e project description

[0.1.0]
* Add class security::selinux 
* Add class base::ntpdate

