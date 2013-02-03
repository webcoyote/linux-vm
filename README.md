# Overview of linux-vm

This project is designed to make it easy to build Linux virtual machines on Windows.

I've written these instructions based on the assumption that you're running vanilla Windows so this should work even if you don't have any of the pre-requisites yet.

## What you get

Here are the features of the Linux virtual machine you will create:

* Gnome desktop, Firefox browser
* Password-less login to local console
* Password-less access to sudo for your account
* SSH key-based login; SSH access via passwords disabled
* Root login disabled (for security)
* Easily update VirtualBox Guest Additions ("vagrant vbguest --do rebuild")
* Optional: installs your "dotfiles" from a separate git repository

## Prerequisites

Install these software packages on your Windows computer

* [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Ruby(Windows)](http://rubyinstaller.org/downloads/)
* [Git](http://git-scm.com/download)

Configure git so that the full set of git utilities, particularly ssh.exe, are accessible. That is, include "...\git\cmd" AND "...\git\bin" in the PATH.

## Configure git

    git config --global user.name "Your Name Here"
    git config --global user.email "your_email@example.com"

## Clone this repository.

In a Windows command-shell run these commands

    :: make the C:\dev directory
    c:
    mkdir \dev
    cd \dev

    :: Clone the repo
    git clone https://github.com/webcoyote/linux-vm
    cd linux-vm

    :: Install required ruby gems
    gem install bundler
    bundle install

## Bug fix for vagrant

Install a bug fix for vagrant in versions less than 1.06 (see https://github.com/mitchellh/vagrant/issues/1212 for details)

    gem uninstall vagrant
    install vagrant using installer: http://downloads.vagrantup.com

## Configuration

Before you build your virtual machine here is your chance to configure it for your requirements. Edit the virtual machine configuration files listed below:

REQUIRED: configure users in data_bags/users/*.json
  * Create a file like "pat.json" with your user settings
  * You can create more users by adding multiple files
  * DELETE pat.json so I don't have access to your computer!

OPTIONAL: configure your virtual machine parameters in ./Vagrantfile
  * OS image, CPU count, memory, networking, etc.

OPTIONAL: add more recipes & packages in recipes/developers.rb

## Build the virtual machine - finally!

In a Windows command-shell type:

    vagrant up

Now wait a bit. My computer takes about 15 minutes to build the VM.


## Update VirtualBox Guest Additions

Your computer may have a different version of VirtualBox than that which was used to build the original virtual machine image. You'll need to upgrade VirtualBox Guest Additions to make things work properly.

Login to the virtual machine and restart it so that it boots into X-windows. This shouldn't be necessary but I have discovered that if you don't then the VirtualBox Guest Additions for X-windows don't work.

On the guest virtual machine login and restart:

    sudo shutdown -f -r now

On the host operating system (after the guest restarts)

    vagrant vbguest

Now reboot the VM one more time so that X-windows restarts with the new additions.

# Common errors

Check the file ERRORS.md for solutions to common problems.

## Middle mouse button

I can't survive without middle-mouse-button scrolling in web browsers. It took me *hours* to find this solution; I am providing it to you so you can avoid this pain yourself. If your middle mouse button is not working, and you're using a Synaptics mouse driver (ThinkPad laptop, others?) then try this:

    c:
    cd "\Program Files\Synaptics\SynTP"
    notepad "TP4table.dat"

    :: In the "Pass 0 rules" section add these lines

        ;VirtualBox.exe
        *,*,VirtualBox.exe,*,*,*,WheelStd,0,9

    :: Kill and restart these processes (or reboot)
        SynTPEnh.exe
        SynTPhelper.exe
        SynTPLpr.exe

    :: From https://forums.virtualbox.org/viewtopic.php?f=6&t=28794

## More

You now have a fully-functional (we hope) Linux virtual machine. There are many more useful software packages you can install to make it fully functional.

Here's another project that I use to automate the process of installing the software that I use:

https://github.com/webcoyote/workstation-setup


# Author

Author:: Patrick Wyatt (pat@codeofhonor.com)

If this doesn't work it is probably my fault, I would appreciate your
feedback so I can fix it for you :)
