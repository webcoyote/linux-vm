name 'base'
description 'base files shared for servers and developers'

run_list  'recipe[curl]',
          'recipe[git]',
          'recipe[openssh]',
          'recipe[build-essential]'
