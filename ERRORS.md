

### ERROR warden: Error occurred: not opened for reading
  Solution:
    You're probably running vagrant 1.0.5
    Install the new version of vagrant 1.0.6.dev

    gem uninstall vagrant
    install vagrant using installer: http://downloads.vagrantup.com

  Details:
    https://github.com/mitchellh/vagrant/issues/1212


### Cookbook not found for linux-vm (Chef::Exceptions::CookbookNotFound)
  Problem:
    The disk mounts probably got flattened

  Solution:
    vagrant reload


### /sbin/mount.vboxsf: mounting failed with the error: No such device
  Error:
    mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` v-root /vagrant
    ERROR vagrant: Vagrant experienced an error! Details:
    ERROR vagrant: #<Vagrant::Errors::VagrantError: The following SSH command responded with a non-zero exit status.
    Vagrant assumes that this means the command failed!
    /sbin/mount.vboxsf: mounting failed with the error: No such device

  Solution:
    VirtualBox guest additions are out-of-date.
    vagrant vbguest --do install --force

### Hang when "Configuring and enabling network interfaces..."
  Similar errors:
    "Waiting for VM to boot. This can take a few minutes."
    "Running provisioner: Vagrant::Provisioners::ChefSolo"

  Error:
    Seems to occur with Centos and dual NICs

  Solution:
    You have to patch the vagrant source code:
      ...\vagrant\embedded\gems\gems\vagrant-1.0.6.dev\lib\vagrant\guest\redhat.rb
    Remove:
           vm.channel.sudo("/sbin/ifup eth#{interface} 2> /dev/null")
    Add:
           # ifup returns a non zero status code in case the network device is already up
           # The provisioning should not fail if network device is already up.
           vm.channel.sudo("/sbin/ifup eth#{interface} 2> /dev/null", :error_check => false)

  Details:
    https://github.com/mitchellh/vagrant/issues/997#commit-ref-b68b2c1

  Other solutions:
    sudo dhclient     # (from the VirtualBox console)

  This solution does not appear to work:
    sudo /etc/init.d/network restart

### Missing cookbooks directory

  This error really means that the "cookbooks" directory on the host is missing

  [default] Mounting shared folders...
  [default] -- v-root: /vagrant
  [default] -- vm_data: /vm_data
  [default] -- v-csr-3: /tmp/vagrant-chef-1/chef-solo-3/roles
  [default] -- v-csc-2: /tmp/vagrant-chef-1/chef-solo-2/cookbooks
  The following SSH command responded with a non-zero exit status.
  Vagrant assumes that this means the command failed!

  mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` v-csc-2 /tmp/vagrant-chef-1/chef-solo-2/cookbooks


### Gnome desktop freezes when you click or type

  => reboot; open ssh session

    remove ~/.Xauthority
