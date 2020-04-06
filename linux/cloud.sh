# This script gets run by a Fractal Cloud Computer to enable Cloud streaming
# This script should only get run on Linux Ubuntu computers
admin_username = "Fractal"
admin_password = "password1234567."
creative_install        = false
datascience_install     = false
gaming_install          = false
productivity_install    = false
softwaredev_install     = false
engineering_install     = false

# Helper function to download Bash scripts from S3 buckets
function GetBashScript {
    echo "Downloading Bash script $1 from $2"
    sudo wget $2
}

# Download utils Bash script with helper functions and import it
GetBashScript "utils.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.sh"
source ./utils.sh

# Run all the basic commands to setup a Fractal cloud computer
Update-Linux
Set-Time
Install-7Zip
Install-Spotify
Install-GoogleChrome
Install-NvidiaTeslaPublicDrivers
Disable-TCC
Set-OptimalGPUSettings
Set-FractalDirectory
Install-FractalServer
Install-ProcessManager
Install-Unison





Install-FractalExitScript




Install-FractalAutoUpdate
Install-FractalWallpaper


Enable-FractalFirewallRule
Install-Unison # SSH Automatically Enabled on Linux


#Disable-Lock
#Disable-Logout
#Disable-Shutdown
Add-AutoLogin $admin_username $admin_password











# Install creative packages
if [ "$creative_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Creative Install script"
    GetBashScript "creative.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/creative.sh"
    sudo bash creative.sh
    echo "Cleaning up Creative Install script"
    sudo rm -f creative.sh
fi

# Install data science packages
if [ "$datascience_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Data Science Install script"
    GetBashScript "datascience.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/datascience.sh"
    sudo bash datascience.sh
    echo "Cleaning up Data Science Install script"
    sudo rm -f datascience.sh
fi

# Install gaming packages
if [ "$gaming_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Gaming Install script"
    GetBashScript "gaming.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/gaming.sh"
    sudo bash gaming.sh
    echo "Cleaning up Gaming Install script"
    sudo rm -f gaming.sh
fi

# Install software development packages
if [ "$softwaredev_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Software Development Install script"
    GetBashScript "softwaredev.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/softwaredev.sh"
    sudo bash softwaredev.sh
    echo "Cleaning up Software Development Install script"
    sudo rm -f softwaredev.sh
fi

# Install engineering packages
if [ "$engineering_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Engineering Install script"
    GetBashScript "engineering.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/engineering.sh"
    sudo bash engineering.sh
    echo "Cleaning up Engineering Install script"
    sudo rm -f engineering.sh
fi

# Install engineering packages
if [ "$productivity_install" = true ] ; then
    # fetch the script, run it and clean
    echo "Launching Productivity Install script"
    GetBashScript "productivity.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/productivity.sh"
    sudo bash productivity.sh
    echo "Cleaning up Productivity Install script"
    sudo rm -f productivity.sh
fi

# Clean Bash install script and restart
echo "Cleaning up Utils script"
sudo rm -f "utils.sh"
sudo reboot