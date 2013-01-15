#
# Cookbook Name:: linux-vm
# Recipe:: developer
#
# Copyright (C) 2012 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'recipe[openssh]' # configure ssh from attributes/ssh.rb
include_recipe 'recipe[zsh]'     # a proper shell
#  'recipe[build-essential]',
#  'recipe[curl]',
#  'recipe[git]',
#  'recipe[firefox]',
#  'recipe[google-chrome]',
#  'recipe[skype]'
