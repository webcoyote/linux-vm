require 'berkshelf/vagrant'
require 'socket'

Vagrant.configure("2") do |config|
  # When you have several of computers and lots of VMs setting the
  # name to something useful is a good idea!
  config.vm.hostname = "vm#{rand(10..99)}--#{Socket.gethostname}"

  config.berkshelf.enabled = true

  # Run this command manually after XWindows is installed:
  # vagrant vbguest --do install
  config.vbguest.auto_update = false

  # OS selection; for a list of boxes see http://www.vagrantbox.es/
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Hardware
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1536]
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--vram", 16]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
    vb.gui = true
  end

  # Network configuration
  #config.vm.forward_port 80, 8080
  #config.vm.network :bridged
  #config.vm.network :hostonly, "192.168.33.10"

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  vm_data = File.expand_path("../vm_data", __FILE__)
  Dir::mkdir(vm_data) unless FileTest::directory?(vm_data)
  config.vm.synced_folder "vm_data", vm_data

  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = "data_bags"
    chef.run_list = [ "recipe[linux-vm::default]" ]
  end
end
