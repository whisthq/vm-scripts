#!/bin/bash
# This script gets run by the Fractal Electron app to enable Peer-to-Peer streaming
# This script should only get run on Linux Ubuntu computers

# Helper function to download Bash scripts from S3 buckets
function GetBashScript {
    echo "Downloading Bash script $1 from $2"
    sudo wget $2
}

# Download utils Bash script with helper functions and import it
GetBashScript "utils.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.sh"
source ./utils.sh

# Run all the basic commands to setup Fractal for Peer-to-Peer streaming
Install-CustomGDMConfiguration
Install-CustomX11Configuration
Set-FractalDirectory
Install-FractalService
Install-FractalServer "master" # install the master branch, could be staging or dev as well
Install-FractalExitScript
Install-FractalAutoUpdate "master" # install the master branch, could be staging or dev as well
Install-FractalLinuxInputDriver
Enable-FractalFirewallRule
Install-Unison # SSH Automatically Enabled on Linux

# Clean Bash install script
echo "Cleaning up Utils script"
sudo rm -f "utils.sh"

# The computer then needs to be restarted before being streamed from
