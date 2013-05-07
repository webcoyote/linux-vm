#!/bin/sh
set -e  # bail on first error
set -u  # bail on unbound variable reference
set -x  # print command before executing it


DEVELOPMENT_DIRECTORY=~/dev

# virtualbox 4.2.12
VIRTUAL_BOX_URL='http://download.virtualbox.org/virtualbox/4.2.12/VirtualBox-4.2.12-84980-OSX.dmg'

# vagrant 1.1.5
VAGRANT_URL='http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/Vagrant-1.2.2.dmg'


InstallVirtualBox() {
  curl -Lo virtualbox.dmg $VIRTUAL_BOX_URL
  hdiutil mount virtualbox.dmg
  sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target /
  hdiutil unmount /Volumes/VirtualBox
}

InstallVagrant() {
  curl -Lo vagrant.dmg $VAGRANT_URL
  hdiutil mount vagrant.dmg
  sudo installer -package /Volumes/Vagrant/Vagrant.pkg -target /
  hdiutil unmount /Volumes/Vagrant
}

InstallVagrantPlugins() {
  # Must not be in the same directory as a Vagrantfile
  # or it might try to load plugins that don't exist
  pushd / 2>&1 >/dev/null
  vagrant plugin install vagrant-berkshelf
  vagrant plugin install vagrant-vbguest
  popd / 2>&1 >/dev/null
}

CloneLinuxVmRepository() {
  mkdir -p "$DEVELOPMENT_DIRECTORY"

  if [[ ! -d "$DEVELOPMENT_DIRECTORY/linux-vm" ]]; then
    git clone https://github.com/webcoyote/linux-vm "$DEVELOPMENT_DIRECTORY/linux-vm"
  fi
}

MakeVirtualMachine() {
  pushd "$DEVELOPMENT_DIRECTORY/linux-vm"

  vagrant up --provider=virtualbox
  vagrant ssh -c "sudo /sbin/init 5"
  vagrant vbguest --auto-reboot

  popd
}


# Ask for the password now so the rest of the install is uninterrupted
sudo true

InstallVirtualBox
InstallVagrant
InstallVagrantPlugins
CloneLinuxVmRepository
MakeVirtualMachine

