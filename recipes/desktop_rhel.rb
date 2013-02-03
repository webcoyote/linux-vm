#
# Cookbook Name:: linux-vm
# Recipe:: desktop_rhel
#

include_recipe 'yum::epel'  # Enterprise Linux
include_recipe 'yum::remi'  # For Firefox

execute "yum update" do
  command "yum update -y"
end

execute "install gnome" do
  command "yum groupinstall -y basic-desktop desktop-platform x11 fonts"
end

# Browser
package "firefox"

# Screensaver
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

execute "set inittab to boot into XWindows" do
  user 'root'
  command "sed --in-place=.bak -r -e 's/id:[0-9]+:initdefault:/id:5:initdefault:/' /etc/inittab"
end
