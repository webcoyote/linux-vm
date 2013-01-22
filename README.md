# Overview of linux-vm

This project is designed to make it easy to build Linux virtual machines on
Windows for use as dev-environment servers or for use as a Linux desktop. Or
at least as easy as it can get: hosting one OS on another takes work!

I've written these instructions based on the assumption that you're running
vanilla Windows, so this should work even if you don't have any of the
pre-requisites yet.

# Features of the Linux virtual machine you will create

* Password-less login to local console
* Password-less access to sudo for your account
* SSH key-based login; SSH access via passwords disabled
* Root login disabled (for security)
* Easily update VirtualBox Guest Additions ("vagrant vbguest --do rebuild")
* Gnome desktop, Firefox browser
* Optional: XMonad window manager
* Optional: installs your "dotfiles" from a separate git repository

# Installation and configuration

Install the software listed below on your Windows box. You'll want to make sure
that Git and Ruby are in the PATH. In particular, it is very helpful to
configure git so that the full set of git utilities in git/bin -- which
includes the indispensable ssh.exe -- are accessible in the path.

* [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Git](http://git-scm.com/download)
* [Ruby(Windows)](http://rubyinstaller.org/downloads/)

Install Ruby gems

    gem install bundler
    bundle install

Now install a fix for vagrant in versions less than 1.06
(see https://github.com/mitchellh/vagrant/issues/1212 for details)

    gem uninstall vagrant
    install vagrant using installer: http://downloads.vagrantup.com

Configure git

    git config --global user.name "Your Name Here"
    git config --global user.email "your_email@example.com"

[Generate ssh keys](https://help.github.com/articles/generating-ssh-keys)

# Cloning the repository

In a Windows command-shell:

    :: clone the repository into c:\dev\linux-vm
    c:
    mkdir \vm_data
    mkdir \dev
    cd \dev
    git clone git@github.com:webcoyote/linux-vm.git
    cd linux-vm

# Edit the virtual machine configuration files

REQUIRED: configure users in data_bags/users/*.json
  * Create a file like "pat.json" with your user settings
  * You can create more users by adding multiple files
  * DELETE pat.json so I don't have access to your computer!

OPTIONAL: configure your virtual machine parameters in ./Vagrantfile
  * OS image, CPU count, memory, networking, etc.

OPTIONAL: add more recipes & packages in recipes/developers.rb

# Build the virtual machine - finally!
In a Windows command-shell:

    vagrant up

    :: ... several minutes from now: success!


# Git note

On Windows, it is necessary to configure repositories to use the git protocol
instead of https to avoid password prompts:

    git remote add origin git@github.com:webcoyote/linux-vm.git

I mention this because, by default GitHub suggests HTTPS-based URLs instead of
GIT-based, and it took me a while to figure out why I had to use a password
when my SSH key was there!


# Mea culpa

If this doesn't work it is probably my fault, I would appreciate your
feedback so I can fix it for you :)

# Author

Author:: Patrick Wyatt (pat@codeofhonor.com)
