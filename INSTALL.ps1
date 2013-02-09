# Install script for linux-vm project
# by Patrick Wyatt 2/6/2013
#
# To run this command:
# @powershell -NoProfile -ExecutionPolicy Unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/webcoyote/linux-vm/master/INSTALL.ps1'))"
#

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
# Environment variables
#-----------------------------------------------
function AppendEnvAndGlobalUserPath ([String]$dir) {
  if (! ($dir.StartsWith(';')) ) {
    $dir = ';' + $dir
  }

  # Add to this shell's environment
  $Env:Path += $dir

  # Add to the global environment
  $path = [Environment]::GetEnvironmentVariable('Path', 'User')
  $path += $dir
  [Environment]::SetEnvironmentVariable('PATH', $path, 'User')
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
  $Env:Path += $Env:ChocolateyInstall + '\bin'
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
  &$GIT_CMD --version > $null
  if ($LASTEXITCODE) {
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
      AppendEnvAndGlobalUserPath ($GIT_INSTALL_DIR + '\cmd')
    }

    3 {
      # => Run Git and included Unix tools from the Windows Command Prompt
      AppendEnvAndGlobalUserPath ($GIT_INSTALL_DIR + '\bin')
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
  $script:VAGRANT_CMD = [Environment]::GetEnvironmentVariable('Path', 'Machine').split(';') |
    Foreach { join-path $_ "vagrant.bat" } |
    Where-Object { Test-Path $_ } |
    Select-Object -First 1

  # Install required gems for this project
  # Can't use "bundle install" because we're modifying
  # vagrant's embedded ruby instead of whatever ruby
  # might already be installed on this computer
  &$script:VAGRANT_CMD gem install berkshelf vagrant-vbguest
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
    &$GIT_CMD clone https://github.com/webcoyote/linux-vm
  }

  Push-Location "$DEVELOPMENT_DIRECTORY\linux-vm"

  # Run Vagrant to bring up the VM
  &$script:VAGRANT_CMD up


  <# wait for Vagrant 1.07 when my ssh changes are incorporated
    # Reboot the computer to switch to "X"
    echo "sudo /sbin/init 5" | vagrant ssh

    # Update VirtualBox guest additions
    vagrant vbguest

    # Restart the computer now that guest additions are up-to-date
    echo "sudo shutdown -f -r now" | vagrant ssh
  #>

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
