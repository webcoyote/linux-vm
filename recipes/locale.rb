#
# Cookbook Name:: linux-vm
# Recipe:: locale

# Set the user's preferred locale using:
# defaults: ../attributes/locale.rb
# template: ../templates/default/locale.erb
template "/etc/default/locale" do
  source "locale.erb"
  owner 'root'
  group 'root'
  mode '0644'
  action :create

  # The original file created upon system installation
  # will be overwritten by the template file. However
  # the user may edit this file later and we don't
  # want to lose those changes, so don't overwrite if
  # the file contains this sentinel.
  not_if "grep CHEF_NO_OVERWRITE /etc/default/locale"
end
