#
# Cookbook Name:: linux-vm
# Recipe:: users
#

# Required recipe for users::sysadmins; replaces functionality
# in Chef that requires access to Chef Server
include_recipe 'chef-solo-search'

# Find any users listed in data_bags/users/*.json that
# are members of sysadmin group and not being removed
# then create those users
include_recipe 'users::sysadmins'

# Configure sudo access to disable insecure login methods
# (i.e. passwords). See attributes/ssh.rb for details.
include_recipe 'sudo'

# Find any users listed in data_bags/users/*.json that
# are members of sysadmin group and not being removed
# then configure those users
search("users", "groups:sysadmin NOT action:remove") do |u|

  # Enable password-less sudo access for this user
  sudo u['id'] do
    user      u['id']
    nopasswd  true
  end

  # Create a password-less SSH key if it doesn't already exist
  execute "generate ssh keys for #{u['id']}" do
    user u['id']
    creates "/home/#{u['id']}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f /home/#{u['id']}/.ssh/id_rsa -P \"\""
  end

  # Install oh-my-zshell if zsh specified; it makes zsh awesome
  if u['shell'] =~ /zsh$/
    git "/home/#{u['id']}/.oh-my-zsh" do
      repository 'git://github.com/robbyrussell/oh-my-zsh.git'
      user u['id']
      group u['id']
      reference 'master'
      action :sync
    end
  end

end
