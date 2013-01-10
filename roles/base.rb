name 'base'
description 'base files'

run_list  'recipe[curl]',
          'recipe[git]',
          'recipe[zsh]',
          'recipe[build-essential]',
          'role[openssh]'