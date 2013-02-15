#
# Cookbook Name:: linux-vm
# Recipe:: desktop_rhel
#

# Update repositories
  include_recipe 'yum::epel'  # Enterprise Linux
  include_recipe 'yum::remi'  # For Firefox
  execute "yum update" do
    command "yum update -y"
  end


# Install Gnome desktop on X11
  execute "install gnome" do
    command "yum groupinstall -y basic-desktop desktop-platform x11 fonts"
  end


# Gnome desktop wants to use NetworkManager instead of the network service.
# Revert back to using the network service, which makes Vagrant more happy
  execute "stop NetworkManager" do
    user 'root'
    command "service NetworkManager stop || true"
  end
  execute "disable NetworkManager" do
    user 'root'
    command "sudo chkconfig NetworkManager off || true"
  end
  execute "start network service" do
    user 'root'
    command "sudo service network start || true"
  end
  execute "enable network service" do
    user 'root'
    command "sudo chkconfig network on || true"
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
    directory "/etc/gdm" do
      owner 'root'
      group 'root'
      mode '0755'
    end

    template "/etc/gdm/custom.conf" do
      source "custom.conf.erb"
      owner 'root'
      group 'root'
      mode '0644'
      action :create
      variables(:username => u['id'])
    end
  end


# Boot into XWindows instead of shell
  execute "set inittab to boot into XWindows" do
    user 'root'
    command "sed --in-place=.bak -r -e 's/id:[0-9]+:initdefault:/id:5:initdefault:/' /etc/inittab"
  end
