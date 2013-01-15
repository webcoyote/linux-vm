name 'developer'
description 'developer workstation'

recipes = [
  'recipe[openssh]',          # configure ssh from attributes/ssh.rb
  'recipe[zsh]',              # a proper shell
#  'recipe[build-essential]',
#  'recipe[curl]',
#  'recipe[git]',
#  'recipe[firefox]',
#  'recipe[google-chrome]',
#  'recipe[skype]'
]
run_list(recipes)
