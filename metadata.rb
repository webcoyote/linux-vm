name             "linux-vm"
maintainer       "Patrick Wyatt"
maintainer_email "pat@codeofhonor.com"
license          "MIT License"
description      "Installs and configures linux-vm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

# Use 1.1.2, which is the last version of this cookbook that doesn't
# have copy-protection checks related to chef-solo
cookbook 'users', '= 1.1.2'

cookbook 'build-essential'
cookbook 'curl'
cookbook 'git'
cookbook 'openssh'
cookbook 'sudo'
cookbook 'zsh'

cookbook 'chef-solo-search'
