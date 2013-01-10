description 'developer workstation'

run_list  'role[base]',
          'recipe[zsh]'
#          'recipe[firefox]',
#          'recipe[google-chrome]',
#          'recipe[skype]'
