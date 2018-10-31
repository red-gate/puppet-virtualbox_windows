$virtualbox_vm_folder_path = 'C:/VirtualBox VMs'

include virtualbox_windows

file { $virtualbox_vm_folder_path:
  ensure  => directory,
  require => Class['virtualbox_windows'],
}
-> virtualbox_windows::property { 'hwvirtexclusive':
  value => 'on',
}
-> virtualbox_windows::property { 'machinefolder':
  value   => $virtualbox_vm_folder_path,
}

class { '::virtualbox_windows::service_identity':
  username => 'vagrant',
  password => 'vagrant',
  require  => Class['virtualbox_windows'],
}

::virtualbox_windows::hostonly_network_adapter { 'VirtualBox Host-Only Ethernet Adapter':
  dhcp_networkaddress => '172.55.127',
}

::virtualbox_windows::hostonly_network_adapter { 'VirtualBox Host-Only Ethernet Adapter #2':
  fixed_ip => '192.168.254.1',
}
