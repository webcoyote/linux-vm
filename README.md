# Linux-VM - Build a virtual machine that runs Linux on Windows in 15 minutes

To build a complete Linux virtual machine (VM) on your Windows computer; just run the following command:

    @powershell -NoProfile -ExecutionPolicy Unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/webcoyote/linux-vm/master/INSTALL.ps1'))"

That's it! In a few minutes (depending upon your Internet speed) your VM will be ready.

Login with the user name: **vagrant**


## About your new Linux virtual machine

Here are the features of the Linux virtual machine you will create (all configurable):

* Linux [Ubuntu](http://www.ubuntu.com/) 12.04 operating system ("precise")
* [Gnome](http://www.gnome.org/) desktop
* [Firefox](http://www.mozilla.org/en-US/firefox/new/) browser

Additional features of your virtual machine:

* Login to the local VM console without typing a password
* Access to sudo without typing a password
* Remotely login to the VM using SSH key-based login
* Remote access to SSH using passwords is disabled (for security)
* Root login disabled (for security)
* VirtualBox Guest Additions updated ("vagrant vbguest")
* Optional: creates a personal account (instead of using "vagrant" account)
* Optional: installs your "dotfiles" from your git repository


## What does installation do?

The installation script installs and configures the required software:

* [Chocolatey](http://chocolatey.org/) (a "package manager" for installing software on Windows)
* [VirtualBox](https://www.virtualbox.org/) (free virtualization software)
* [Git](http://git-scm.com/) (revision control software)
* [Vagrant](http://vagrantup.com/) (a virtual machine configuration utility)
* [Berkshelf](http://berkshelf.com/) (a vagrant plugin for maintaining VM recipes)

If you'd like to know more read the installation script: https://github.com/webcoyote/linux-vm/blob/master/INSTALL.ps1


## Common errors

Read [ERRORS.md](https://github.com/webcoyote/linux-vm/blob/master/ERRORS.md) for solutions to common problems.


## Middle mouse button

If you're like me you can't survive without middle-mouse-button scrolling in web browsers. It took me *hours* to discover how to get my mouse to work, so I'll provide the information here so you can avoid this pain yourself. If your middle mouse button is not working, and you're using a Synaptics mouse driver (ThinkPad laptop, others?) then try this:

    c:
    cd "\Program Files\Synaptics\SynTP"
    notepad "TP4table.dat"

    :: In the "Pass 0 rules" section add these lines:

        ;VirtualBox.exe
        *,*,VirtualBox.exe,*,*,*,WheelStd,0,9

    :: Kill and restart these processes (or reboot your computer:)
        SynTPEnh.exe
        SynTPhelper.exe
        SynTPLpr.exe

    :: From https://forums.virtualbox.org/viewtopic.php?f=6&t=28794

## Customization

Once you've created the virtual machine you can edit these configuration files to modify your existing virtual machine or create an entirely different one

### Add users

Follow the directions in .\linux-vm\data_bags\template\yournamehere.json and then run:

    vagrant provision

### Change the OS parameters

Want to change the amount of memory in your virtual machine, or make it use more processors? Want to configure the networking mode? Want to change the operating system altogether?

Edit .\linux-vm\Vagrantfile and then run:

    vagrant reload

## More

You now have a Linux virtual machine with a graphical desktop. There are many more useful software packages you can install to make it fully functional. Here is another project that I use to automate the process of installing the software that I use:

https://github.com/webcoyote/workstation-setup


# Author

Author:: Patrick Wyatt (pat@codeofhonor.com)

If this doesn't work it is probably my fault, I would appreciate your feedback so I can fix it for you :)
