# Install script for linux-vm project
# by Patrick Wyatt 2/6/2013
#
# To run this command:
# @powershell -NoProfile -ExecutionPolicy Unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/webcoyote/linux-vm/master/INSTALL.ps1'))"
#


# Fail on errors
$ErrorActionPreference = 'Stop'


#-----------------------------------------------
# Configuration -- change these settings if desired
#-----------------------------------------------

  # Where do you like your projects installed?
  # For me it is C:\dev but you can change it here:
  $DEVELOPMENT_DIRECTORY = $Env:SystemDrive + '\xdev'

  # By default Chocolatey wants to install to C:\chocolatey
  # but lots of folks on Hacker News don't like that. Override
  # the default directory here:
  $CHOCOLATEY_DIRECTORY = $Env:SystemDrive + '\chocolatey'

  # Git has three installation mode:
  #   1. Use Git Bash only
  #   2. Run Git from the Windows Command Prompt
  #   3. Run Git and included Unix tools from the Windows Command Prompt
  #
  # You probably want #2 or #3 so you can use git from a DOS command shell
  # More details: http://www.geekgumbo.com/2010/04/09/installing-git-on-windows/
  #
  # Pick one:
  $GIT_INSTALL_MODE=3


#-----------------------------------------------
# Constants
#-----------------------------------------------
#TODO: discover where git is installed using the same trick as for Vagrant
  # Git is assumed to be installed here, which is true
  # as of 2/7/2013. But I can't control what the package
  # manager does so I'll hardcode these here and check
  $GIT_INSTALL_DIR = ${Env:ProgramFiles(x86)} + '\Git'
  $GIT_CMD = $GIT_INSTALL_DIR + '\cmd\git.exe'


#-----------------------------------------------
#
#-----------------------------------------------
function Exec
{
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=1)]
        [ScriptBlock]$Command,
        [Parameter(Position=1, Mandatory=0)]
        [string]$ErrorMessage = "ERROR: command failed:`n$Command"
    )

    &$Command

    if ($LastExitCode -ne 0) {
        write-host $ErrorMessage
        exit 1
    }
}

<#
# What the fuck!?! PowerShell is supposed to be a scripting language
# for system administrators, not a descent into the bowels of hell!
# I understand *why* this happens, but not *how* a language could be
# designed to work like this!

  function Append ([String]$path, [String]$dir) {
    [String]::concat($path, ";", $dir)
  }
  [String]::concat("a;b;c", ";", "d") # => a;b;c;d
  Append("a;b;c", "d")                # => a;b;c d;
  Append "a;b;c", "d"                 # => a;b;c d;
  Append "a;b;c" "d"                  # => a;b;c;d
#>

#-----------------------------------------------
# Environment variables
#-----------------------------------------------
function AppendPath ([String]$path, [String]$dir) {
  $result = $path.split(';') + $dir.split(';') |
      where { $_ -ne '' } |
      select -uniq
  [String]::join(';', $result)
}
# AppendPath ";a;b;;c;" ";d;"    => a;b;c;d

function AppendEnvAndGlobalPath ([String]$dir, [String]$target) {
  # Add to this shell's environment
  $Env:Path = AppendPath $Env:path $dir

  # Add to the global environment; $target => { 'Machine', User' }
  $path = [Environment]::GetEnvironmentVariable('Path', $target)
  $path = AppendPath $path $dir
  [Environment]::SetEnvironmentVariable('Path', $path, $target)
}

function FindInEnvironmentPath ([String]$file) {
  [Environment]::GetEnvironmentVariable('Path', 'Machine').split(';') +
  [Environment]::GetEnvironmentVariable('Path', 'User').split(';') |
    where { $_ -ne '' } |
    foreach { join-path $_ $file } |
    Where-Object { Test-Path $_ } |
    Select-Object -First 1
}

#-----------------------------------------------
# Install Chocolatey package manager
#-----------------------------------------------
function InstallPackageManager () {
  # Set Chocolatey directory unless already set or program already installed
  if (! $Env:ChocolateyInstall) {
    $Env:ChocolateyInstall = $CHOCOLATEY_DIRECTORY
  }

  # Save install location for future shells. Any shells that have already
  # been started will not pick up this environment variable (Windows limitation)
  [Environment]::SetEnvironmentVariable(
    'ChocolateyInstall',
    $Env:ChocolateyInstall,
    'User'
  )

  # Install Chocolatey
  $url = 'http://chocolatey.org/install.ps1'
  iex ((new-object net.webclient).DownloadString($url))

  # Chocolatey sets the global path; set it for this shell too
  $Env:Path += "$Env:ChocolateyInstall\bin"
}


#-----------------------------------------------
# Git
#-----------------------------------------------
function InstallGit () {

  # Install the git package
  cinst git

  # Verify git installed
  if (! (Test-Path $GIT_CMD) ) {
    write-host "ERROR: I thought I just installed git but now I can't find it here:"
    write-host ("--> " + $GIT_CMD)
    exit 1
  }

  # Verify git runnable
  &$GIT_CMD --version
  if ($LASTEXITCODE -ne 0) {
    write-host "ERROR: Unable to run git; did it install correctly?"
    write-host ("--> '" + $GIT_CMD + "' --version")
    exit 1
  }

  # Fix path based on git installation mode
  switch ($GIT_INSTALL_MODE) {
    1 {
      # => Use Git Bash only
      # blank
    }

    2 {
      # => Run Git from the Windows Command Prompt
      AppendEnvAndGlobalPath "$GIT_INSTALL_DIR\cmd" "User"
    }

    3 {
      # => Run Git and included Unix tools from the Windows Command Prompt
      AppendEnvAndGlobalPath "$GIT_INSTALL_DIR\bin" "User"
    }
  }

}


#-----------------------------------------------
# Vagrant
#-----------------------------------------------
function InstallVagrant () {
  # Install my version of vagrant instead of the default version.
  # Why my version:
  # * Uses the latest version of Vagrant (1.0.6)
  # * Does NOT include jruby dependency (no longer required for vagrant)
  # * Does NOT include putty dependency (yuck - use ssh.exe from git)
  cinst vagrant-base

  #write-host "*** Path: "
  #write-host ($Env:path)
  #write-host "*** Machine: "
  #write-host ([Environment]::GetEnvironmentVariable('Path', 'Machine'))
  #write-host "*** User: "
  #write-host ([Environment]::GetEnvironmentVariable('Path', 'User'))

  # While we just installed vagrant, it's only in the machine path, not in
  # the environment for this shell yet. So... go find vagrant
  $script:VAGRANT_CMD = FindInEnvironmentPath "vagrant.bat"

  # Install required gems for this project
  # Can't use "bundle install" because we're modifying
  # vagrant's embedded ruby instead of whatever ruby
  # might already be installed on this computer
  write-host installing Berkshelf
  Exec { &$VAGRANT_CMD gem install berkshelf vagrant-vbguest }
  write-host Berkshelf complete
}


#-----------------------------------------------
# Make virtual machine
#-----------------------------------------------
function MakeVirtualMachine () {
  # Create the development directory
  if (! (Test-Path $DEVELOPMENT_DIRECTORY -pathType container) ) {
    New-Item -ItemType directory -Path $DEVELOPMENT_DIRECTORY >$null
  }

  # Clone the repository
  if (! (Test-Path "$DEVELOPMENT_DIRECTORY\linux-vm\" -pathType container) ) {
    &$GIT_CMD clone https://github.com/webcoyote/linux-vm "$DEVELOPMENT_DIRECTORY\linux-vm"
    if ($LASTEXITCODE -ne 0) {
      write-host "ERROR: Unable to clone https://github.com/webcoyote/linux-vm"
      exit 1
    }
  }

  Push-Location "$DEVELOPMENT_DIRECTORY\linux-vm"

  # Run Vagrant to bring up the VM
  Exec { &$VAGRANT_CMD up }

  # The virtual machine is now complete! But ...
  # VirtualBox Guest Additions may not be up to date.
  # To correct this use vagrant vbguest. My experience
  # has been that it is necessary to be in graphics
  # mode before upgrading and to reboot afterwards,
  # otherwise the guest desktop does not resize properly
  # when resizing its window on the host system.

  # shutdown the machine so that when it reboots it
  # will start in runmode 5 (graphics). It may be
  # possible to shortcut this with this instead:
  #     echo "sudo /sbin/init 5" | vagrant ssh
  # .. but only when my ssh changes are incorporated (Vagrant > 1.0.6)
  write-host "Restarting virtual machine"
  Exec { &$VAGRANT_CMD reload --no-provision }

  # Update VirtualBox guest additions
  write-host "Updating VirtualBox guest additions"
  Exec { &$VAGRANT_CMD vbguest }

  # Restart the computer now that guest additions are up-to-date
  write-host "Restarting virtual machine again"
  Exec { &$VAGRANT_CMD reload --no-provision }

  Pop-Location
}


#-----------------------------------------------
# Main
#-----------------------------------------------

# Install Chocolatey
InstallPackageManager

# Install packages to C:\Bin so the root directory isn't polluted
cinst binroot

# Install required packages
InstallGit
InstallVagrant
MakeVirtualMachine


# Can I mention here how frequently PowerShell violates the principle of least surprise?
