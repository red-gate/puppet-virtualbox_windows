# PRIVATE CLASS: do not use directly
class virtualbox_windows::params {
  # The path where the VirtualBox Vms will be saved to
  $virtualbox_vm_folder_path = 'D:/VirtualBox VMs'
  $virtualbox_version        = '5.0.14.105127'
  $vboxmanage                = 'C:/Program Files/Oracle/VirtualBox/VBoxManage.exe'
  $hwvirtexclusive           = 'on'
  $vboxmanage_search_paths   = ['C:/Program Files/Oracle/VirtualBox']
}
