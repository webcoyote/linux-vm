#
# Cookbook Name:: linux-vm
# Recipe:: desktop_debian
#

# Install desktop
  execute "update apt" do
    command "apt-get update -y"
  end

# Install ubuntu desktop (uses unity)
  session="ubuntu"
  execute "install ubuntu-desktop (with unity)" do
    command "apt-get install -y ubuntu-desktop"
  end


# Replace unity with gnome
  session="gnome"
  execute "install gnome shell" do
    command "apt-get install -y gnome-shell"
  end


# Disable screensaver
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
      variables(:username => u['id'], :session => session)
    end
  end


# Browser
  package "firefox"
