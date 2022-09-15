# Install virtualbox on windows.
class virtualbox_windows(
  $virtualbox_version = $virtualbox_windows::params::virtualbox_version,
  $vboxmanage = $virtualbox_windows::params::vboxmanage
  ) inherits virtualbox_windows::params {

    require chocolatey

    package { 'virtualbox':
      ensure          => $virtualbox_version,
      provider        => 'chocolatey',
      install_options => ['--allow-empty-checksums'],
    }

    case versioncmp($virtualbox_version, '6.1.30')
    {
      1:
      {
        # If the version of VB is greater than version 6.1.30 then 'vboxdrv' no longer exists on Windows.
        $manage_vbox_drv = false
      }
      default:
      {
        # If the version of VB is less than or equal to 6.1.30 then 'vboxdrv' does exist and we should manage it.
        $manage_vbox_drv = trues
      }
    }
    if ($manage_vbox_drv == true)
    {
      # Make sure the Virtualbox kernel driver is running
      service { 'vboxdrv':
        ensure  => 'running',
        enable  => true,
        require => Package['virtualbox']
      }
    }
}
