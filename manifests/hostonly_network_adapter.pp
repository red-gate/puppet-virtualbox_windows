# Configure a Host-Only Network Adapter.
define virtualbox_windows::hostonly_network_adapter(
  $adapter_name = $title,
  $dhcp_networkaddress = undef,
  $fixed_ip = undef
  ) {

  require virtualbox_windows

  Exec {
    provider  => 'powershell',
    logoutput => true,
  }

  exec { "Create ${adapter_name}":
    command => "& \"${::virtualbox_windows::vboxmanage}\" hostonlyif create",
    onlyif  => template('virtualbox_windows/should_create_adapter.ps1.erb'),
  }

  if $dhcp_networkaddress {

    $adapter_ipaddress = "${dhcp_networkaddress}.1"
    $dhcp_ipaddress = "${dhcp_networkaddress}.2"
    $dhcp_lower_ip_range = "${dhcp_networkaddress}.3"
    $dhcp_upper_ip_range = "${dhcp_networkaddress}.254"
    $dhcp_netname = "HostInterfaceNetworking-${adapter_name}"

    exec { "${adapter_name}: add dhcp server" :
      command => "& \"${::virtualbox_windows::vboxmanage}\" dhcpserver add --netname \"${dhcp_netname}\" --ip ${dhcp_ipaddress} --netmask 255.255.255.0 --lowerip ${dhcp_lower_ip_range} --upperip ${dhcp_upper_ip_range} --enable",
      onlyif  => template('virtualbox_windows/should_create_dhcp_server.ps1.erb'),
      require => Exec["Create ${adapter_name}"],
    }

    -> exec { "${adapter_name}: setup dhcp server" :
      command => "& \"${::virtualbox_windows::vboxmanage}\" dhcpserver modify --netname \"${dhcp_netname}\" --ip ${dhcp_ipaddress} --netmask 255.255.255.0 --lowerip ${dhcp_lower_ip_range} --upperip ${dhcp_upper_ip_range} --enable",
      onlyif  => template('virtualbox_windows/should_set_dhcp_server_properties.ps1.erb'),
    }

    -> exec { "${adapter_name}: Set ip to ${adapter_ipaddress}" :
      command => "& \"${::virtualbox_windows::vboxmanage}\" hostonlyif ipconfig \"${adapter_name}\" --ip ${adapter_ipaddress}",
      onlyif  => template('virtualbox_windows/should_set_adapter_ip.ps1.erb'),
    }

    ~> exec { "${adapter_name}: enable dhcp" :
      command => "& \"${::virtualbox_windows::vboxmanage}\" hostonlyif ipconfig \"${adapter_name}\" --dhcp",
      onlyif  => template('virtualbox_windows/should_set_adapter_dhcp.ps1.erb'),
    }

  } elsif $fixed_ip {

    $adapter_ipaddress = $fixed_ip

    exec { "${adapter_name}: set ip to ${adapter_ipaddress}" :
      command => "& \"${::virtualbox_windows::vboxmanage}\" hostonlyif ipconfig \"${adapter_name}\" --ip ${adapter_ipaddress}",
      onlyif  => template('virtualbox_windows/should_set_adapter_ip.ps1.erb'),
      require => Exec["Create ${adapter_name}"]
    }

  } else {
    warn('Need to either set dhcp_networkaddress or fixed_ip')
  }
}
