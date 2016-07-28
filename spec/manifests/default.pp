$virtualbox_vm_folder_path = 'C:/VirtualBox VMs'
$dhcp_networkaddress = '172.55.127'

include virtualbox_windows

file { $virtualbox_vm_folder_path:
  ensure  => directory,
  require => Class['virtualbox_windows'],
}
->
virtualbox_windows::property { 'hwvirtexclusive':
  value => 'on',
}
->
virtualbox_windows::property { 'machinefolder':
  value   => $virtualbox_vm_folder_path,
}

class { '::virtualbox_windows::hostonly_network_adapter':
  dhcp_networkaddress => $dhcp_networkaddress
}
Class['virtualbox_windows'] -> Class['virtualbox_windows::hostonly_network_adapter']
