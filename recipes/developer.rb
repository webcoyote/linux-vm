#
# Cookbook Name:: linux-vm
# Recipe:: developer
#

include_recipe 'openssh' # configure ssh from attributes/ssh.rb
include_recipe 'git'
include_recipe 'zsh'     # a proper shell

#include_recipe 'build-essential'
#include_recipe 'curl'
#include_recipe 'firefox'
#include_recipe 'google-chrome'
#include_recipe 'skype'

#package 'tree'
#package 'wget'
#package 'ntp'
#package 'meld'
#package 'devilspie'
#package 'sqlitebrowser'
