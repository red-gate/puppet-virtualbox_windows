$virtualbox_vm_folder_path = 'C:/VirtualBox VMs'

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

class { '::virtualbox_windows::service_identity':
  username => 'vagrant',
  password => 'vagrant',
  require  => Class['virtualbox_windows'],
}

class { '::virtualbox_windows::hostonly_network_adapter':
  require             => Class['virtualbox_windows'],
}
