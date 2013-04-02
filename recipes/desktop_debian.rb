#
# Cookbook Name:: linux-vm
# Recipe:: desktop_debian
#

#supdate apt-get -y update
#sudo apt-get install -y python-software-properties
#sudo add-apt-repository -y ppa:gnome3-team/gnome3
#command "apt-get install ubuntu-gnome-desktop ubuntu-gnome-default-settings"


# Install desktop
  execute "update apt" do
    command "apt-get update -y"
  end

  execute "install gnome" do
    command "apt-get install -y ubuntu-desktop"
  end


# Browser
  package "firefox"


# Disable creensaver
  search("users", "disable-screensaver:true NOT action:remove") do |u|
    execute "disable screen saver for #{u['id']}" do
      user u['id']
      command "gconftool-2 --set -t boolean /apps/gnome-screensaver/idle_activation_enabled false"
    end
  end


# Enable one user to login automatically to the console
  search("users", "desktop-autologin:true NOT action:remove") do |u|
    directory "/etc/lightdm" do
      owner 'root'
      group 'root'
      mode '0755'
    end

    template "/etc/lightdm/lightdm.conf" do
      source "lightdm.conf.erb"
      owner 'root'
      group 'root'
      mode '0644'
      action :create
      variables(:username => u['id'])
    end
  end
