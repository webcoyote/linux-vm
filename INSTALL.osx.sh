#!/bin/sh

DEVELOPMENT_DIRECTORY=~/dev

# virtualbox 4.2.12
VIRTUAL_BOX_URL='http://download.virtualbox.org/virtualbox/4.2.12/VirtualBox-4.2.12-84980-OSX.dmg'

# vagrant 1.1.5
VAGRANT_URL='http://files.vagrantup.com/packages/64e360814c3ad960d810456add977fd4c7d47ce6/Vagrant.dmg'


InstallVirtualBox() {
  curl -Lo virtualbox.dmg $VIRTUAL_BOX_URL
  hdiutil mount virtualbox.dmg
  sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target "/Volumes/Macintosh HD"
  hdiutil unmount /Volumes/VirtualBox
}

InstallVagrant() {
  curl -Lo vagrant.dmg $VAGRANT_URL
  hdiutil mount vagrant.dmg
  sudo installer -package /Volumes/Vagrant/Vagrant.pkg -target "/Volumes/Macintosh HD"
  hdiutil unmount /Volumes/Vagrant
}

InstallVagrantPlugins() {
  vagrant plugin install berkshelf-vagrant
  vagrant plugin install vagrant-vbguest
}

CloneLinuxVmRepository() {
  mkdir -p "$DEVELOPMENT_DIRECTORY"
  git clone https://github.com/webcoyote/linux-vm "$DEVELOPMENT_DIRECTORY/linux-vm"
}

MakeVirtualMachine() {
  pushd "$DEVELOPMENT_DIRECTORY/linux-vm"

  vagrant up --provider=virtualbox
  vagrant ssh -c "sudo /sbin/init 5"
  vagrant vbguest --autoreboot

  popd
}


set -e  # bail on first error
set -u  # bail on unbound variable reference
set -x  # print command before executing it

InstallVirtualBox
InstallVagrant
InstallVagrantPlugins
CloneLinuxVmRepository
MakeVirtualMachine
