class osNode {
  ### MOTD
  $motdTemplateErb ="
#########################################################
# Hello, welcome to the '<%= @hostname %>'.
#########################################################
# Hostname		: <%= @fqdn %>
<% if @domain %>
# Domain		: <%= @domain %>
<% end %>
# IP address		: <%= @ipaddress %> / <%= @netmask %>
# Operating System	: <%= @operatingsystem %>  <%= @operatingsystemrelease %> [kernel ver <%= @kernelversion %> ]
<% if @is_virtual == 'true' %>
# Virtual		: <%= @productname %> - <%= @virtual %>
<% end %>
# Total CPU / MEM 	: <%= @processorcount %> / <%= @memorysize_mb %> MB
# SECURITY - SELINUX	: <%= @selinux_config_mode %> / <%= @selinux_current_mode %>
# TIMEZONE		: <%= @timezone %>
######################################################
"
  class {'linux::base::motd' :
    content => inline_template($motdTemplateErb)
  }

  ### timezone
  class {'linux::base::timezone' :
    timezone => 'UTC',
  }
}

