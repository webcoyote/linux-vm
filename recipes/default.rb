#
# Cookbook Name:: linux-vm
# Recipe:: default
#

# Include other internal recipes from this repo
include_recipe "linux-vm::developer"
include_recipe "linux-vm::locale"
include_recipe "linux-vm::users"

case node['platform_family']
when "rhel"
  include_recipe "linux-vm::desktop_rhel"
when "debian"
  include_recipe "linux-vm::desktop_debian"
end
