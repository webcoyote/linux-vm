#
# Cookbook Name:: linux-vm
# Recipe:: users
#
# Copyright (C) 2012 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Set sudo options
# messing with this will break vagrant; be careful
node.set[:authorization][:sudo][:include_sudoers_d] = true
node.set[:authorization][:sudo][:sudoers_defaults] = [
  '!visiblepw',
  'env_reset',
  'env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
  'env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
  'env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
  'env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
  'env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
  'env_keep += "HOME"',
  'always_set_home',
  'secure_path = /sbin:/bin:/usr/sbin:/usr/bin'
]

include_recipe 'recipe[chef-solo-search]', # required for users::sysadmins
include_recipe 'recipe[users::sysadmins]'
include_recipe 'recipe[sudo]'

sudo 'pat' do
  user      'pat'
  nopasswd  true
end
