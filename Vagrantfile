require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  config.vm.host_name = "devbox"

  # OS selection
  config.vm.box = "Berkshelf-CentOS-6.3-x86_64-minimal"
  config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"

  # Hardware
  config.vm.customize ["modifyvm", :id, "--memory", 1536]
  config.vm.customize ["modifyvm", :id, "--cpus", 2]

  # Network configuration
  #config.vm.network :bridged
  config.vm.network :hostonly, "192.168.33.10"
  #config.vm.forward_port 80, 8080

  # Show GUI mode in VirtualBox
  #config.vm.boot_mode = :gui

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  Dir::mkdir("/vm_data") unless FileTest::directory?("/vm_data")
  config.vm.share_folder "vm_data", "/vm_data", "/vm_data"

  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = "./data_bags"
    chef.run_list = [
      "recipe[linux-vm::default]",
      "recipe[chef-solo-search]",
      "recipe[users::sysadmins]",
    ]

    chef.roles_path = "roles"
    chef.add_role("developer")
  end
end
