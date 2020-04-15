#!/bin/bash
# This script gets run by a Fractal Cloud Computer to enable Cloud streaming
# This script should only get run on Linux Ubuntu computers
# This script is part 1 of 2 scripts needed to enable Cloud steaming

# Helper function to download Bash scripts from S3 buckets
function GetBashScript {
    echo "Downloading Bash script $1 from $2"
    sudo wget $2
}

# Download utils Bash script with helper functions and import it
GetBashScript "utils.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.sh"
source ./utils.sh

# Run sudo so it's not prompted in the following commands and install basic packages
yes | printf "password1234567." | sudo apt-get install wget python python3

# Run all the basic command to setup Gnome and Linux virtual display
Install-VirtualDisplay # Requires rebooting

# Clean Bash install script and restart
echo "Cleaning up Utils script"
sudo rm -f "utils.sh"
sudo reboot