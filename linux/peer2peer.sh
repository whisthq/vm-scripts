# This script gets run by the Fractal Electron app to enable Peer-to-Peer streaming
# It is run on user's computers being transformed into Fractal streaming servers
# This script only runs on Linux Ubuntu computers

# Download utils Bash script with helper functions and import it
echo "Downloading utils.sh from AWS S3"
sudo wget "utils.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.sh"
source ./utils.sh

# Run all the basic commands to setup Fractal for Peer-to-Peer streaming
Install-CustomGDMConfiguration
Install-CustomX11Configuration
Set-FractalDirectory
Install-FractalService "master" # install the master branch, could be staging or dev as well
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
