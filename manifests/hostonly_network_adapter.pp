# Configure a Host-Only Network Adapter
class virtualbox_windows::hostonly_network_adapter(
  $adapter_name = 'VirtualBox Host-Only Ethernet Adapter',
  $dhcp_networkaddress = '172.28.128'
  ) {

  $adapter_idaddress = "${dhcp_networkaddress}.1"
  $dhcp_ipaddress = "${dhcp_networkaddress}.2"
  $dhcp_lower_ip_range = "${dhcp_networkaddress}.3"
  $dhcp_upper_ip_range = "${dhcp_networkaddress}.254"
  $dhcp_netname = "HostInterfaceNetworking-${adapter_name}"

  Exec {
    provider  => 'powershell',
    logoutput => true,
    path      => 'C:/Program Files/Oracle/VirtualBox',
  }

  exec { 'Create VirtualBox host only adapter':
    command => 'VBoxManage hostonlyif create',
    onlyif  => template('virtualbox_windows/should_create_adapter.ps1.erb'),
  }
  ->
  exec { 'Virtualbox: vboxmanage dhcpserver add' :
    command => "VBoxManage dhcpserver add --netname \"${dhcp_netname}\" --ip ${dhcp_ipaddress} --netmask 255.255.255.0 --lowerip ${dhcp_lower_ip_range} --upperip ${dhcp_upper_ip_range} --enable",
    onlyif  => template('virtualbox_windows/should_create_dhcp_server.ps1.erb'),
  }
  ->
  exec { 'Virtualbox: vboxmanage dhcpserver modify' :
    command => "VBoxManage dhcpserver modify --netname \"${dhcp_netname}\" --ip ${dhcp_ipaddress} --netmask 255.255.255.0 --lowerip ${dhcp_lower_ip_range} --upperip ${dhcp_upper_ip_range} --enable",
    onlyif  => template('virtualbox_windows/should_set_dhcp_server_properties.ps1.erb'),
  }
  ->
  exec { "Set VirtualBox Host-Only Ethernet Adapter IP to ${adapter_idaddress}" :
    command => "VBoxManage hostonlyif ipconfig \"VirtualBox Host-Only Ethernet Adapter\" --ip ${adapter_idaddress}",
    onlyif  => template('virtualbox_windows/should_set_adapter_properties.ps1.erb'),
  }
  ->
  exec { 'Set VirtualBox Host-Only Ethernet Adapter DHCP' :
    command     => "VBoxManage hostonlyif ipconfig \"VirtualBox Host-Only Ethernet Adapter\" --dhcp",
    refreshonly => true,
    subscribe   => Exec["Set VirtualBox Host-Only Ethernet Adapter IP to ${adapter_idaddress}"]
  }

}
