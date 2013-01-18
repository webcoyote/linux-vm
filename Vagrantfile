require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  config.vm.host_name = "devbox"

  # vbguest does not work on CentOS; disable for now and do it manually
  # submitted https://github.com/dotless-de/vagrant-vbguest/issues/39
  config.vbguest.auto_update = false

  # OS selection; for a list of boxes see http://www.vagrantbox.es/
    # Use Ubuntu Lucid Lynx image from
      config.vm.box = "lucid64"
      config.vm.box_url = "http://files.vagrantup.com/lucid64.box"
    # Use CentOS 6.3 image from Berkshelf https://github.com/reset/veewee-berkshelf
      #config.vm.box = "Berkshelf-CentOS-6.3-x86_64-minimal"
      #config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"

  # Hardware
  config.vm.customize ["modifyvm", :id, "--memory", 1536]
  config.vm.customize ["modifyvm", :id, "--cpus", 2]

  # Network configuration
  config.vm.network :bridged
  #config.vm.network :hostonly, "192.168.33.10"
  #config.vm.forward_port 80, 8080

  # Show GUI mode in VirtualBox
  #config.vm.boot_mode = :gui

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  Dir::mkdir("/vm_data") unless FileTest::directory?("/vm_data")
  config.vm.share_folder "vm_data", "/vm_data", "/vm_data"

  config.vm.provision :chef_solo do |chef|
    #chef.log_level = :debug
    chef.data_bags_path = "data_bags"
    chef.run_list = [ "recipe[linux-vm::default]" ]
  end
end
