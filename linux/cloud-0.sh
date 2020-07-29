#!/bin/bash

# This script gets run on a Fractal Cloud Computer/Container to enable Cloud streaming
# This script should only get run on Linux Ubuntu computers
# This script is part 1 of 2 scripts needed to enable Cloud streaming
# Usage: ./cloud-0.sh [VM PASSWORD]

# Changes to exit script immediately if any command fails
set -e
export DEBIAN_FRONTEND="noninteractive"

# Define whether this is running locally for testing or on a cloud environment
LOCAL=${LOCAL:=no}

# Run sudo so it's not prompted in the following commands and install basic packages
if [ $LOCAL = no ]; then
    printf "$1" | sudo apt-get -y install wget python python3
else
    sudo apt-get -y install wget python python3
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR
source $DIR/utils.sh

# Run all the basic command to setup Gnome and Linux virtual display
echo "Installing Virtual Display"
Update-Linux
Install-VirtualDisplay # Requires rebooting

echo "cloud-0.sh complete! Restarting!"

# Clean Bash install script and restart
sudo reboot

