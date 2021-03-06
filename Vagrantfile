# -*- mode: ruby -*-
# vi: set ft=ruby :

puppetVersion = "4.5.2"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define "web-vm", primary: true do |web|
      # The most common configuration options are documented and commented below.
      # For a complete reference, please see the online documentation at
      # https://docs.vagrantup.com.
      # Every Vagrant development environment requires a box. You can search for
      # boxes at https://atlas.hashicorp.com/search.
      web.vm.box = "centos/7"

      # Disable automatic box update checking. If you disable this, then
      # boxes will only be checked for updates when the user runs
      # `vagrant box outdated`. This is not recommended.
      web.vm.box_check_update = true

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine. In the example below,
      # accessing "localhost:8080" will access port 80 on the guest machine.
      # config.vm.network "forwarded_port", guest: 80, host: 8080
      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      # config.vm.network "private_network", ip: "192.168.33.10"
      # Create a public network, which generally matched to bridged network.
      # Bridged networks make the machine appear as another physical device on
      # your network.
      # config.vm.network "public_network"

      # Share an additional folder to the guest VM. The first argument is
      # the path on the host to the actual folder. The second argument is
      # the path on the guest to mount the folder. And the optional third
      # argument is a set of non-required options.
      # config.vm.synced_folder "../data", "/vagrant_data"
      # Provider-specific configuration so you can fine-tune various
      # backing providers for Vagrant. These expose provider-specific options.
      # Example for VirtualBox:
      #
      web.vm.provider "virtualbox" do |vb|
      #   # Display the VirtualBox GUI when booting the machine
        vb.gui = false
      #
      #   # Customize the amount of memory on the VM:
        vb.memory = "512"
	    vb.cpus=2
      end
      #
      # View the documentation for the provider you are using for more
      # information on available options.

      # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
      # such as FTP and Heroku are also available. See the documentation at
      # https://docs.vagrantup.com/v2/push/atlas.html for more information.
      # config.push.define "atlas" do |push|
      #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
      # end

      # Enable provisioning with a shell script. Additional provisioners such as
      # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
      # documentation for more information about their specific syntax and use.
      # config.vm.provision "shell", inline: <<-SHELL
      #   apt-get update
      #   apt-get install -y apache2

      #web.vm.synced_folder ".", "/home/vagrant/play-scala-akka-cassandra-demo",
		#	#group: "www-data", owner:"www-data",
		#	mount_options: ['dmode=775', 'fmode=774']
      web.vm.synced_folder ".", "/home/vagrant/play-scala-akka-cassandra-demo", type: "nfs"

      web.ssh.insert_key = false
      web.puppet_install.puppet_version = puppetVersion
      web.vm.hostname = "web.dev"
      web.vm.network "forwarded_port", guest: 80, host: 8080
      web.vm.network "private_network", ip: "10.10.1.10"
      web.librarian_puppet.puppetfile_dir = "puppet/environments/web"
      web.vm.provision "puppet" do |puppet|
	    puppet.environment = 'web'
	    puppet.environment_path = "puppet/environments"
        puppet.options = "--verbose --summarize --reports store"
        puppet.module_path = "puppet/environments/web/modules"
      end
  end
  
  config.vm.define "db-vm" do |db|
    db.vm.box = "centos/7"
    db.vm.box_check_update = true
    db.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
      vb.cpus = 2
    end

	db.vm.network "private_network", ip: "10.10.10.10"
    db.vm.synced_folder ".", "/home/vagrant/play-scala-akka-cassandra-demo",
      			#group: "www-data", owner:"www-data", 
                        mount_options: ['dmode=775', 'fmode=774']
 
    db.ssh.insert_key = false
    db.puppet_install.puppet_version = puppetVersion
    db.vm.hostname = "db.dev"
    db.vm.network "forwarded_port", guest: 9000, host: 9000
    db.vm.network "forwarded_port", guest: 8500, host: 8500
    db.librarian_puppet.puppetfile_dir = "puppet/environments/db"
    db.vm.provision "puppet" do |puppet|
        puppet.environment = 'db'
        puppet.environment_path = 'puppet/environments'
        puppet.options = "--verbose --summarize --reports store"
        puppet.module_path = "puppet/environments/db/modules"
    end
  end

  $es_cluster_size = 2 # max 9
  $es_cluster_size.times do |n|
    id = n+1
    ip = "10.10.20.1#{id}"
    name = "es-0#{id}"

    config.vm.define name do |es|
        es.vm.box = "centos/7"
        es.vm.box_check_update = true
        es.vm.provider "virtualbox" do |vb|
          vb.gui = false
          vb.memory = "256"
          vb.cpus = 2
        end

	    es.vm.network "private_network", ip: ip
        es.vm.synced_folder ".", "/home/vagrant/play-scala-akka-cassandra-demo",
      	    		#group: "www-data", owner:"www-data",
                            mount_options: ['dmode=775', 'fmode=774']
        es.ssh.insert_key = false
        es.puppet_install.puppet_version = puppetVersion
        es.vm.hostname = name
        #es.vm.network "forwarded_port", guest: 9200, host: 9200
        es.librarian_puppet.puppetfile_dir = "puppet/environments/db"
        es.vm.provision "puppet" do |puppet|
            puppet.environment = 'db'
            puppet.environment_path = 'puppet/environments'
            puppet.options = "--verbose --summarize --reports store"
            puppet.module_path = "puppet/environments/db/modules"
        end
    end
  end

  $cassandra_cluster_size = 3 # max 9
  $cassandra_cluster_size.times do |n|
    id = n+1
    ip = "10.10.30.1#{id}"
    name = "cassandra-0#{id}"

    config.vm.define name do |cas|
        cas.vm.box = "centos/7"
        cas.vm.box_check_update = true
        cas.vm.provider "virtualbox" do |vb|
            vb.gui = false
            vb.memory = "512"
            vb.cpus = 2
        end

      cas.vm.network "private_network", ip: ip
      cas.vm.synced_folder ".", "/home/vagrant/play-scala-akka-cassandra-demo",
                        #group: "www-data", owner:"www-data",
                              mount_options: ['dmode=775', 'fmode=774']
      cas.ssh.insert_key = false
      cas.puppet_install.puppet_version = puppetVersion
      cas.vm.hostname = name
      cas.librarian_puppet.puppetfile_dir = "puppet/environments/db"
      cas.vm.provision "puppet" do |puppet|
          puppet.environment = 'db'
          puppet.environment_path = 'puppet/environments'
          puppet.options = "--verbose --summarize --reports store"
          puppet.module_path = "puppet/environments/db/modules"
      end
    end
  end

    $titandb_cluster_size = 1 # max 9
    $titandb_cluster_size.times do |n|
      id = n+1
      ip = "10.10.40.1#{id}"
      name = "titandb-0#{id}"

      config.vm.define name do |tit|
          tit.vm.box = "centos/7"
          tit.vm.box_check_update = true
          tit.vm.provider "virtualbox" do |vb|
              vb.gui = false
              vb.memory = "512"
              vb.cpus = 2
          end

        tit.vm.network "private_network", ip: ip
        tit.vm.synced_folder ".", "/home/vagrant/play-scala-akka-cassandra-demo",
                          #group: "www-data", owner:"www-data",
                                mount_options: ['dmode=775', 'fmode=774']
        tit.ssh.insert_key = false
        tit.puppet_install.puppet_version = puppetVersion
        tit.vm.hostname = name
        tit.librarian_puppet.puppetfile_dir = "puppet/environments/db"
        tit.vm.provision "puppet" do |puppet|
            puppet.environment = 'db'
            puppet.environment_path = 'puppet/environments'
            puppet.options = "--verbose --summarize --reports store"
            puppet.module_path = "puppet/environments/db/modules"
        end
      end
    end
end
