#
# Cookbook Name:: linux-vm
# Recipe:: developer
#

# Install recipes specified in ../metadata.rb and ../Berskfile
include_recipe 'git'      # required for this recipe to work
include_recipe 'openssh'  # configure ssh from attributes/ssh.rb
include_recipe 'zsh'      # a proper shell
include_recipe 'curl'     # Internet swiss-army knife
include_recipe 'build-essential'

# Add useful packages
package 'wget'            # like curl, only different
package 'tree'            # list directory structure in tree format
package 'patch'           # apply diff-patches; required for RVM & etc.

# add your recipes here; remember they must be listed in:
#   ../metadata.rb (for recipes from Opscode)
#   ../Berksfile   (for recipes from other locations)

# Add your packages here
#package 'ntp'

