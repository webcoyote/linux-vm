# Overview of linux-vm

To build a complete Linux virtual machine (VM) on your Windows computer; just run the following command:

    @powershell -NoProfile -ExecutionPolicy Unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/webcoyote/linux-vm/master/INSTALL.ps1'))"

That's it!

In about 15 minutes (depending upon your Internet speed) your VM will be ready.


## About your new Linux virtual machine

Here are the features of the Linux virtual machine you will create:

* Linux CentOS 6.3 operating system
* Gnome desktop
* Firefox browser

Additional features of your virtual machine
* Login to the local VM console without typing a password
* Access to sudo without typing a password
* Remotely login to the VM using SSH key-based login
* Remote access to SSH using passwords is disabled (for security)
* Root login disabled (for security)
* VirtualBox Guest Additions updated ("vagrant vbguest")
* Optional: creates a personal account (instead of using "vagrant" account)
* Optional: installs your "dotfiles" from your git repository


## What does installation do?

The installation script assumes that you don't have any of the required software already installed on your computer, and installs it for you:
* Chocolatey (a "package manager" for installing software on Windows)
* Oracle VirtualBox (free virtualization software)
* Vagrant (a virtual machine configuration utility)
* Git (revision control software)

If you'd like to know the details you can read the installation script here: https://github.com/webcoyote/linux-vm/blob/master/INSTALL.ps1


# Common errors


Check ERRORS.md (https://github.com/webcoyote/linux-vm/blob/master/ERRORS.md) for solutions to common problems.


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
