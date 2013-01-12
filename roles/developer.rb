name 'developer'
description 'developer workstation'

recipes = [
#  'recipe[build-essential]',
#  'recipe[curl]',
#  'recipe[git]',
  'recipe[openssh]',
  'recipe[sudo]',
  'recipe[zsh]'

#  'recipe[firefox]',
#  'recipe[google-chrome]',
#  'recipe[skype]'
]

run_list(recipes)

override_attributes(
  :authorization => {
    :sudo => {
      :users => ["vagrant", "pat"],
      :passwordless => true
    }
  }
)
