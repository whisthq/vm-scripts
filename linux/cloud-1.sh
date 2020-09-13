#!/bin/bash
# This script gets run on a Fractal Cloud Computer/Container to enable Cloud streaming
# This script should only get run on Linux Ubuntu computers
# This script is part 2 of 2 scripts needed to enable Cloud streaming
# Usage: ./cloud-1.sh [VM/CONTAINER PASSWORD]

# protocol branch to download, could also be dev or staging
protocol_branch="master"

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
Disable-AutomaticLockScreen-Gnome
Disable-Logout-Gnome

echo "cloud-1.sh complete! Restarting!"

# Clean Bash install script and restart
echo "Cleaning up Utils script"
if [ $LOCAL = no ]; then
    sudo rm -f "utils.sh"
    $(sleep 1; sudo reboot) &
elif [ $LOCAL = yes ]; then
    echo "Skipping reboot"
fi
