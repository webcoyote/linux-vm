# Todo

## Move recipes from this cookbook into pivotal_workstation and workstation_setup repos.

- leave this recipe to build a server box
- all client stuff should done during the post-boot process so that it can be used for physical computers as well as VMs

    Gnome Desktop
    XMonad
    Firefox
    meld
    gnome-system-monitor


## Configure git

cat | ~/.gitconfig <<EOF
[user]
  name = Patrick Wyatt
  email = pat@codeofhonor.com

[diff]
  tool = meld

[difftool]
  prompt = false
EOF


## Network

CentOS box is a bit cranky with dual NICs.
=> does not work: Add "GATEWAYDEV=eth1" to /etc/sysconfig/network


## SSH

Need to change insecure private key for vagrant; it's baked into base-boxes and is therefore insecure --> this would be easy if vagrant incorporates the change-request for multi-SSH key.

