# This script gets run by the Fractal Electron app to enable Peer-to-Peer streaming
# It is run on user's computers being transformed into Fractal streaming servers
# This script only runs on Windows computers

# Set the execution policy to enable running Powershell modules and scripts
Set-ExecutionPolicy RemoteSigned -Force

# Helper function to download the PowerShell scripts from S3 buckets
function GetPowerShellScript ($script_name, $script_url) {
    Write-Output "Downloading Powershell script $script_name from $script_url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($script_url, $script_name)
}

# Download utils PowerShell script with helper functions
$utils_script_name = "C:\utils.psm1"
$utils_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.psm1"
GetPowerShellScript $utils_script_name $utils_script_url
Import-Module "$utils_script_name"

# Run all the basic commands to setup Fractal for Peer-to-Peer streaming
Update-Firewall
Set-FractalDirectory
Install-FractalService "master" # install the master branch, could be staging or dev as well
Install-FractalServer "master" # install the master branch, could be staging or dev as well
Install-FractalExitScript
Install-FractalAutoUpdate "master" # install the master branch, could be staging or dev as well
Enable-FractalFirewallRule
Install-Unison
Enable-SSHServer
Install-ViGEm

# Clean PowerShell install script
Write-Output "Cleaning up Utils script"
Remove-Item -Path $utils_script_name -Confirm:$false

# The computer then needs to be restarted before being streamed from
