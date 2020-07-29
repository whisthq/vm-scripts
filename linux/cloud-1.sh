#!/bin/bash

# This script gets run on a Fractal Cloud Computer/Container to enable Cloud streaming
# This script should only get run on Linux Ubuntu computers
# This script is part 2 of 2 scripts needed to enable Cloud streaming
# Usage: ./cloud-1.sh [VM PASSWORD]

# variable blocks for optional installs
protocol_branch="master" # protocol branch to download, could also be dev or staging
creative_install=false
datascience_install=false
gaming_install=false
productivity_install=false
softwaredev_install=false
engineering_install=false

# Changes to exit script immediately if any command fails
set -e
export DEBIAN_FRONTEND="noninteractive"

# Whether to run these functions locally or on a cloud VM/container
LOCAL=${LOCAL:=no}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR
source $DIR/utils.sh

# Run sudo so it's not prompted in the following commands, and install basic packages
printf "$1" | sudo apt-get -y install wget python python3

# Run all the basic commands to setup a Fractal cloud computer (Install-VirtualDisplay done in cloud-0.sh)
Update-Linux
Set-Time
Install-7Zip
Install-Curl
Install-NvidiaTeslaPublicDrivers
Disable-TCC
Set-OptimalGPUSettings
Install-CustomGDMConfiguration
Install-CustomX11Configuration
Set-FractalDirectory
Install-FractalServer $protocol_branch
Install-FractalService $protocol_branch
Install-FractalExitScript
Install-FractalAutoUpdate $protocol_branch
Install-FractalLinuxInputDriver
Install-FractalWallpaper
Enable-FractalFirewallRule
Install-Unison # SSH Automatically Enabled on Linux
Enable-SSHKey
Disable-Shutdown
Add-AutoLogin
Disable-AutomaticLockScreen

# Install creative packages
if [ "$creative_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Creative Install script"
    sudo bash creative.sh
    echo "Cleaning up Creative Install script"
    sudo rm -rf creative.sh
fi

# Install data science packages
if [ "$datascience_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Data Science Install script"
    sudo bash datascience.sh
    echo "Cleaning up Data Science Install script"
    sudo rm -rf datascience.sh
fi

# Install gaming packages
if [ "$gaming_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Gaming Install script"
    sudo bash gaming.sh
    echo "Cleaning up Gaming Install script"
    sudo rm -rf gaming.sh
fi

# Install software development packages
if [ "$softwaredev_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Software Development Install script"
    sudo bash softwaredev.sh
    echo "Cleaning up Software Development Install script"
    sudo rm -rf softwaredev.sh
fi

# Install engineering packages
if [ "$engineering_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Engineering Install script"
    sudo bash engineering.sh
    echo "Cleaning up Engineering Install script"
    sudo rm -rf engineering.sh
fi

# Install engineering packages
if [ "$productivity_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Productivity Install script"
    sudo bash productivity.sh
    echo "Cleaning up Productivity Install script"
    sudo rm -rf productivity.sh
fi

echo "cloud-1.sh complete! Restarting!"

# Clean Bash install script and restart
echo "Cleaning up Utils script"
if [ $LOCAL = no ]; then
    sudo rm -f "utils.sh"
    $(sleep 1; sudo reboot) &
elif [ $LOCAL = yes ]; then
    echo "Skipping reboot"
fi

