#
# Cookbook Name:: linux-vm
# Recipe:: users
#

include_recipe 'chef-solo-search' # required for users::sysadmins
include_recipe 'users::sysadmins'
include_recipe 'sudo'

# Configure users
admins = [ "pat" ]
admins.each do |user|

  sudo user do
    user      user
    nopasswd  true
  end

  execute "generate ssh keys for #{user}" do
    user user
    creates "/home/#{user}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f /home/#{user}/.ssh/id_rsa -P \"\""
  end

  git "/home/#{user}/.oh-my-zsh" do
    repository 'git://github.com/robbyrussell/oh-my-zsh.git'
    user user
    group user
    reference 'master'
    action :sync
  end

end
