#!/bin/bash
# This script gets run by a Fractal Cloud Computer to enable Cloud streaming
# This script should only get run on Linux Ubuntu computers
# This script is part 1 of 2 scripts needed to enable Cloud streaming

# Helper function to download Bash scripts from S3 buckets
function GetBashScript {
    echo "Downloading Bash script $1 from $2"
    sudo wget -q $2
}

# Changes to exit script immediately if any command fails
set -e
export DEBIAN_FRONTEND="noninteractive"

# Run sudo so it's not prompted in the following commands and install basic packages
LOCAL=${LOCAL:=no}
if [ $LOCAL = no ]; then
    printf "password1234567." | sudo apt-get -y install wget python python3
else
    sudo apt-get -y install wget python python3
fi

# Download utils Bash script with helper functions and import it
if [ $LOCAL = no ]; then
    GetBashScript "utils.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.sh"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR
source $DIR/utils.sh

# Run all the basic command to setup Gnome and Linux virtual display
echo Installing virtual display
Update-Linux
Install-VirtualDisplay # Requires rebooting

# Clean Bash install script and restart
echo "Cleaning up Utils script"

if [ $LOCAL = no ]; then
    sudo rm -f "utils.sh"
    sudo reboot
elif [ $LOCAL = yes ]; then
    echo Skipping reboot
fi
