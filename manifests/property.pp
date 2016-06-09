# Manage a virtualbox property
define virtualbox_windows::property($value, $property_xmlname = $property_name, $property_name = $title) {
  include ::virtualbox_windows::params

  # Because not all the names of the properties as set in VirtualBox.xml match the names of the properties
  # expected by vboxmanage setproperty :(
  $property_xmlconfig_name = $property_name ? {
    'hwvirtexclusive' => 'exclusiveHwVirt',
    'machinefolder' => 'defaultMachineFolder',
    default => undef
  }
  if $property_xmlconfig_name == undef {
    fail("Not implemented for property: ${property_name}")
  }

  $property_xmlconfig_value = $value ? {
    'on' => true,
    'off' => false,
    default => $value
  }

  exec { "Set ${property_name}=${value}":
    command   => "VBoxManage setproperty \"${property_name}\" \"${value}\"",
    require   => Package['virtualbox'],
    onlyif    => template('virtualbox_windows/should_set_property.ps1.erb'),
    provider  => 'powershell',
    logoutput => true,
    path      => $::virtualbox_windows::params::vboxmanage_search_paths,
  }

}
