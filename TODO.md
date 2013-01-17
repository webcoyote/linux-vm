
## Todo


## Guest additions

Install correct guest additions for VM

## SSH
Need to change insecure private key for vagrant; it's baked into lucid64 and is therefore insecure --> this would be easy if vagrant incorporates the change-request for multi-SSH key

Remove ./*-ssh.bat files --> this would be easy if vagrant incorporates my change request


## Sublime (and other stuff)
http://www.technoreply.com/how-to-install-sublime-text-2-on-ubuntu-12-04-unity/
https://github.com/jtimberman/chef-fundamentals-repo/tree/master/cookbooks/knife-workstation

##

Add X desktop for developers

  #============================================================================
  # Enable first user to auto-login in XWindows (if ubuntu-desktop installed)
  directory "/etc/gdm" do
    owner 'root'
    group 'root'
    mode '0755'
  end

  file "/etc/gdm/custom.conf" do
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    content <<-END.gsub(/^ {4}/, '')
[daemon]
TimedLoginEnable=true
AutomaticLoginEnable=true
TimedLogin=#{admins[0]}
AutomaticLogin=#{admins[0]}
TimedLoginDelay=0
DefaultSession=gnome
END
  end


# More recipes & packages

  #include_recipe 'firefox'
  #include_recipe 'google-chrome'
  #include_recipe 'skype'

  #package 'meld'
  #package 'devilspie'
  #package 'sqlitebrowser'
