source 'https://rubygems.org'

gem 'puppet-lint'

gem 'test-kitchen', '~> 1'
gem 'kitchen-puppet', :github => 'red-gate/kitchen-puppet', :branch => 'master'
gem 'kitchen-vagrant', '~> 0'

# needed by the vagrant-winrm vagrant plugin which is needed by kitchen-vagrant in order to be able to use winrm
gem 'winrm-fs', '~> 1'
gem 'winrm-elevated', '~> 1'

# We use serverspec to test the state of our servers
gem 'serverspec', '~> 2'
# use our fork of specinfra which supports winrm v2. (Needed for Powershell v5+)
gem 'specinfra', :github => 'red-gate/specinfra', :branch => 'winrm-v2'

# We use rake as our build engine
gem 'rake', '~> 11'
# This gem tells us how long each rake task takes.
gem 'rake-performance'

# We use r10k to download our puppet modules.
# We do use our own fork which contains a fix/workaround for SSL validation on windows.
gem 'r10k', :github => 'red-gate/r10k', :branch => '2.0.x'
