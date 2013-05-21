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
  $DEVELOPMENT_DIRECTORY = $Env:SystemDrive + '\dev'

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
# Utility functions
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
# Path-handling
#-----------------------------------------------
# AppendPath ";a;b;;c;" ";d;"    => a;b;c;d
function AppendPath ([String]$path, [String]$dir) {
  $result = $path.split(';') + $dir.split(';') |
      where { $_ -ne '' } |
      select -uniq
  [String]::join(';', $result)
}

function AppendEnvAndGlobalPath ([String]$dir, [String]$target) {
  # Add to this shell's environment
  $Env:Path = AppendPath $Env:path $dir

  # Add to the global environment; $target => { 'Machine', User' }
  $path = [Environment]::GetEnvironmentVariable('Path', $target)
  $path = AppendPath $path $dir
  [Environment]::SetEnvironmentVariable('Path', $path, $target)
}

function FindInRegistryPath ([String]$file) {
  $fullpath = (
    [Environment]::GetEnvironmentVariable('Path', 'Machine').split(';') +
    [Environment]::GetEnvironmentVariable('Path', 'User').split(';') |
      where { $_ -ne '' } |
      foreach { join-path $_ $file } |
      Where-Object { Test-Path $_ } |
      Select-Object -First 1
  )

  if ($fullpath -eq $null) {
    write-host "ERROR: Cannot find '$fullpath' in the path"
    exit 1
  }

  $fullpath
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

  # Install packages to C:\Bin so the root directory isn't polluted
  cinst binroot
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
  cinst vagrant
}

function InstallVagrantPlugins () {
  # Trying to install Berkshelf while including a Vagrantfile that references
  # Berkshelf doesn't work so change to a directory that should not contain
  # a Vagrantfile.
  $savePath = $env:path
  Push-Location "C:\"

  # Berkshelf requires components that must be compiled with the Ruby DevKit
  $vagrantCmd = FindInRegistryPath vagrant.bat
  $vagrantDir = split-path -parent $vagrantCmd | split-path -parent
  $devkit     = join-path $vagrantDir "embedded"
  $env:path = "$devkit\bin;$devkit\mingw\bin;$env:path"

  Exec { &$vagrantCmd plugin install vagrant-berkshelf }
  Exec { &$vagrantCmd plugin install vagrant-vbguest }

  Pop-Location
  $env:path = $savePath
}


#-----------------------------------------------
# Make virtual machine
#-----------------------------------------------
function InstallVirtualBox () {
  cinst virtualbox
}

function CloneLinuxVmRepository () {
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
}

function MakeVirtualMachine () {
  Push-Location "$DEVELOPMENT_DIRECTORY\linux-vm"

  # Run Vagrant to bring up the VM
  $vagrantCmd = FindInRegistryPath vagrant.bat
  Exec { &$vagrantCmd up --provider=virtualbox }

  # The virtual machine is now complete! But ...
  # VirtualBox Guest Additions may not be up to date.
  # To correct this use vagrant vbguest. My experience
  # has been that it is necessary to be in graphics
  # mode before upgrading and to reboot afterwards,
  # otherwise the guest desktop does not resize properly
  # when resizing its window on the host system.

  # Switch to graphics mode
  Exec { &$vagrantCmd ssh -c "sudo /sbin/init 5" }

  # Update VirtualBox guest additions
  write-host "Updating VirtualBox guest additions"
  Exec { &$vagrantCmd vbguest --auto-reboot }

  Pop-Location
}


#-----------------------------------------------
# Main
#-----------------------------------------------

InstallPackageManager
InstallGit
InstallVirtualBox
InstallVagrant
InstallVagrantPlugins
CloneLinuxVmRepository
MakeVirtualMachine


# Can I mention here how frequently PowerShell violates the principle of least surprise?

write-host @"

If you've just run this script for the first time you should exit this
command shell and start another so your PATH variable is set correctly.
"@
