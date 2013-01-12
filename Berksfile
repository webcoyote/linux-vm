site :opscode

metadata

# chef-solo-search is used to replace the chef "search" functionality
# provided by chef-server so that we can use chef-solo. This removes
# the necessity to use knife.rb and have a .pem file
cookbook 'chef-solo-search', :git => 'git://github.com/webcoyote/chef-solo-search.git'

# Use 1.1.2, which is the last version of this cookbook that doesn't
# have copy-protection checks related to chef-solo
cookbook 'users', '= 1.1.2'

#cookbook 'build-essential'
#cookbook 'curl'
#cookbook 'git'
cookbook 'openssh'
cookbook 'sudo'
cookbook 'zsh'
