# Overview of linux-vm

This project is designed to make it easy to build Linux virtual machines on Windows.

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

Install the software packages on your Windows computer:

* [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://downloads.vagrantup.com/)
* [Git](http://git-scm.com/download)

Note: I find it useful to install Git with the setting "Run Git and included Unix tools from the Windows Command Prompt" to that ssh.exe is accessible on the command-line.

## Clone "this" repository

In a Windows command-shell run these commands

    :: make the C:\dev directory
    c:
    mkdir \dev
    cd \dev

    :: Clone the repo
    git clone https://github.com/webcoyote/linux-vm
    cd linux-vm

    :: Install required ruby gems into the ruby
    :: embedded with vagrant
    vagrant gem install berkshelf vagrant-vbguest


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
