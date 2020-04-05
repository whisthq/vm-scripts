# This script gets run by the Fractal Electron app to enable Peer-to-Peer streaming
# This script should only get run on Linux Ubuntu computers

# Helper function to download Bash scripts from S3 buckets
function GetBashScript {
    echo "Downloading Bash script $1 from $2"
    sudo wget $2
}

# Download utils Bash script with helper functions
GetBashScript "utils.sh" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.sh"










#TODO START
# Run all the basic commands to setup Fractal for Peer-to-Peer streaming
Update-Firewall
Set-FractalDirectory
Install-FractalService
Install-FractalServer
Install-FractalExitScript
Install-FractalAutoUpdate
Enable-FractalFirewallRule
Install-Unison
Enable-SSHServer
#TODO END





# Clean Bash install script
echo "Cleaning up Utils script"
rm -f "utils.sh"

# The computer then needs to be restarted before being streamed from