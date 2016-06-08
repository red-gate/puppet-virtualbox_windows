# Install virtualbox on windows.
class virtualbox_windows(
  $virtualbox_version        = $virtualbox_windows::params::virtualbox_version,
  $virtualbox_vm_folder_path = $virtualbox_windows::params::virtualbox_vm_folder_path,
  $hwvirtexclusive           = $virtualbox_windows::params::hwvirtexclusive
  ) inherits virtualbox_windows::params {

    file { $virtualbox_vm_folder_path:
      ensure => directory,
    }
    ->
    package { 'virtualbox':
      ensure   => $virtualbox_version,
      provider => 'chocolatey',
    }
    ->
    virtualbox_windows::property { 'hwvirtexclusive':
      value => $hwvirtexclusive,
    }
    ->
    virtualbox_windows::property { 'machinefolder':
      value   => $virtualbox_vm_folder_path,
      require => File[$virtualbox_vm_folder_path],
    }

    contain virtualbox_windows::hostonly_network_adapter
    Package['virtualbox'] -> Class['virtualbox_windows::hostonly_network_adapter']
}
