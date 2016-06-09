# Install virtualbox on windows.
class virtualbox_windows(
  $virtualbox_version = $virtualbox_windows::params::virtualbox_version
  ) inherits virtualbox_windows::params {

    package { 'virtualbox':
      ensure   => $virtualbox_version,
      provider => 'chocolatey',
    }

}
