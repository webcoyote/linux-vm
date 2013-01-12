name 'base'
description 'base files shared for servers and developers'

run_list  'recipe[build-essential]',
          'recipe[curl]',
          'recipe[git]',
          'recipe[openssh]'
