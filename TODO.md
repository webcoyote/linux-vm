# Todo

## Move recipes from this cookbook into pivotal_workstation and workstation_setup repos.

- leave this recipe to build a server box
- all client stuff should done during the post-boot process so that it can be used for physical computers as well as VMs

    Gnome Desktop
    Firefox
    gnome-system-monitor


## Network

CentOS box is a bit cranky with dual NICs
* Disable network manager and enable network
  http://xmodulo.com/2013/01/how-to-configure-networking-in-centos-desktop-with-command-line.html
* Add "GATEWAYDEV=eth1" to /etc/sysconfig/network


## SSH

Need to change insecure private key for vagrant; it's baked into base-boxes and is therefore insecure --> this would be easy if vagrant incorporates the change-request for multi-SSH key.

