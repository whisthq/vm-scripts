# This script gets run by the Fractal Electron app to enable Peer-to-Peer streaming
# This script should only get run on Windows computers

# Set the execution policy to enable running Powershell modules and scripts
Set-ExecutionPolicy RemoteSigned -Force

# Helper function to download the PowerShell scripts from S3 buckets
function GetPowerShellScript ($script_name, $script_url) {
    Write-Output "Downloading Powershell script $script_name from $script_url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $webClient = new-object System.Net.WebClient
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
Install-FractalService
Install-FractalServer
Install-FractalExitScript $true # true -> dynamic paths (does not work on Fractal VMs via webserver)
Install-FractalAutoUpdate
Enable-FractalFirewallRule
Install-Unison
Enable-SSHServer

# Clean PowerShell install script
Write-Output "Cleaning up Utils script"
Remove-Item -Path $utils_script_name -Confirm:$false

# The computer then needs to be restarted before being streamed from