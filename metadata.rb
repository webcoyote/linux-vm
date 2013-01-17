name             "linux-vm"
maintainer       "Patrick Wyatt"
maintainer_email "pat@codeofhonor.com"
license          "MIT License"
description      "Installs and configures linux-vm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.0"

%w{ubuntu debian centos redhat amazon scientific fedora}.each do |os|
  supports os
end

# Cookbooks from Opscode
  # Use 1.1.2, which is the last version of this cookbook that doesn't
  # have copy-protection checks related to chef-solo
  depends 'users', '= 1.1.2'

  depends 'build-essential'
  depends 'curl'
  depends 'git'
  depends 'openssh'
  depends 'sudo'
  depends 'zsh'

# Cookbooks with dependencies listed in Berksfile
  depends 'chef-solo-search'
