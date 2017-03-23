# Encoding: utf-8
require_relative 'spec_windowshelper'

describe file('C:/VirtualBox VMs') do
  it { should be_directory  }
end

describe package('Oracle VM VirtualBox 5.0.14') do
  it { should be_installed}
end

describe command('& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list hostonlyifs') do
  its(:stdout) { should match /Name:\s+VirtualBox Host-Only Ethernet Adapter/ }
  its(:stdout) { should match /IPAddress:\s+172\.28\.128\.\d+/ }
  its(:stdout) { should match /DHCP:\s+Enabled/ }
  # There should be only 1 network adapter defined. (so no line break before the first property 'Name:')
  its(:stdout) { should_not match /[\r\n]Name:/ }
end

describe command('& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list dhcpservers') do
  its(:stdout) { should match /NetworkName:\s+HostInterfaceNetworking-VirtualBox Host-Only Ethernet Adapter/ }
  its(:stdout) { should match /IP:\s+172\.28\.128\.2/ }
  its(:stdout) { should match /NetworkMask:\s+255\.255\.240\.0/ }
  its(:stdout) { should match /lowerIPAddress:\s+172\.28\.128\.3/ }
  its(:stdout) { should match /upperIPAddress:\s+172\.28\.143\.254/ }
  its(:stdout) { should match /Enabled:\s+Yes/ }
  # There should be only 1 network adapter defined. (so no line break before the first property 'Name:')
  its(:stdout) { should_not match /[\r\n]NetworkName:/ }
end

describe windows_registry_key('HKEY_CLASSES_ROOT\AppID\{819B4D85-9CEE-493C-B6FC-64FFE759B3C9}') do
  it { should have_property_value('RunAs', :type_string, "vagrant") }
end
