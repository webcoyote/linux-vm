
# Using the Windows key for xmonad

If you're reading this, perhaps you've decided to give my [linux-vm scripts](https://github.com/webcoyote/linux-vm) a try and have installed a Linux virtual machine onto your Windows laptop. Awesome. Next, you may have used my [workstation-setup](https://github.com/webcoyote/workstation-setup) scripts a spin to install and configure the software you like to use most. Sweet!

And if you're like me, you've discovered the [xmonad dynamically tiling window manager](http://xmonad.org/), which is flat out the best Linux window manager in existence: tiling, minimal, stable, extensible, featureful, easy and friendly. I got hooked.

But after a while you discovered that using the Alt-key for the "mod" key has a serious limitation: so many other pieces of software already use Alt-key combinations. So... let's find a totally unused key on the keyboard. Hey, what about the Windows key. In fact, remapping that key would be a bonus because it is negatively useful -- pressing it only causes grief. Yes yes, I know some folks like it -- logging out is so much easier using Windows-L...

But for the rest of us, here's how to make the Windows key work as the mod key for xmonad, which is epic.

## On your Windows laptop

0. Install [SharpKeys](http://sharpkeys.codeplex.com/), which allows you to remap keys on your keyboard.  Here is the direct download link to the no-install version: http://sharpkeys.codeplex.com/downloads/get/319725. Do not use KeyTweak or MapKeyboard -- SharpKeys is the simplest. All these programs do is modify a special registry entry, so they don't have to stay resident in memory once they're done.

1. Remap "Left Windows key" to "F15", which is an unused key on modern keyboards.

2. Reboot. Pressing the Windows key no longer has any effect in Windows, since nothing is mapped to F15.

## On your Linux virtual machine

0. Configure ~/xmonad.hs to use

    modMask = mod3Mask
    
  Here is my xmonad configuration file: https://github.com/webcoyote/pivotal_workstation/blob/master/templates/default/xmonad.hs
  
1. Recompile:

    xmonad --recompile

2. Discover what key the Windows key appears to be by pressing and releasing the Windows key several times. Then run this command:

    dmesg | tail -5
    
    You should see output that looks roughly like this:

    atkbd.c: Unknown key released (translated set 2, code 0x66 on isa0060/serio0).
    atkbd.c: Use 'setkeycodes 66 <keycode>' to make it known.

3. Map the key using the setkeycodes program. We'll map the key to "Super L"

    sudo setkeycodes 66 133
    
4. Run the "xev" program and type the "Left Windows" key several times. Weird. On my system it shows XF86Copy (0x8d) as the key instead?!? Whatever. Let's go with that

    xev

5. Set the xmodmap function to use XF86Copy as the mod3 key

    xmodmap -e "clear mod3" -e "add mod3 = XF86Copy"

6. If you're lucky, your left Windows key should be behaving as the mod3 key now. Try LeftWindows+Shift + Enter, which will open a terminal.

7. Last step: we want this setting to persist after reboot, so run these commands:

    sudo sh -c 'echo -e "#!/bin/sh\n\nsetkeycodes 66 133\n" > /etc/init.d/xmonadkey ; chmod 755 /etc/init.d/xmonadkey'
    sudo ln -s /etc/init.d/xmonadkey /etc/rc3.d/S90xmonadkey
    sudo ln -s /etc/init.d/xmonadkey /etc/rc5.d/S90xmonadkey

##References:

* http://www.jveweb.net/en/archives/2011/01/configure-unrecognized-keys-in-linux.html
* https://wiki.archlinux.org/index.php/Extra_Keyboard_Keys
