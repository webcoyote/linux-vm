name 'developer'
description 'developer workstation'

recipes = [
  'recipe[chef-solo-search]', # required for users::sysadmins
  'recipe[users::sysadmins]', # create users listed in data_bags/users/*
  'recipe[openssh]',          # configure ssh from attributes/ssh.rb
  'recipe[sudo]',             # configure sudo from attributes below
  'recipe[zsh]',              # a proper shell
#  'recipe[build-essential]',
#  'recipe[curl]',
#  'recipe[git]',
#  'recipe[firefox]',
#  'recipe[google-chrome]',
#  'recipe[skype]'
]
run_list(recipes)


# Set sudo options
# messing with this will break vagrant; be careful
sudoers_defaults = [
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
override_attributes(
  :authorization => {
    :sudo => {
      :include_sudoers_d => true,
      :sudoers_defaults => sudoers_defaults,
    }
  }
)
