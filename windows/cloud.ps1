# This script gets run (as Administrator) by a Fractal Cloud Computer to enable Cloud streaming
# This script should only get run on Windows computers
# Usage: cloud.ps1 [VM/CONTAINER PASSWORD] [[OPTIONAL] PROTOCOL-BRANCH]

# The settings here will default to the values on the right, which should all be fine kept as is except
# for the admin_password, which should be specificed based on the VM
param (
    [SecureString]  $admin_password         = (ConvertTo-SecureString "password1234567." -AsPlainText -Force),
    [string]        $protocol_branch        = "master", # protocol branch to pull, either master, staging or dev
    [string]        $admin_username         = "Fractal",
    [SecureString]  $certificate_password   = (ConvertTo-SecureString "certificate-password1234567." -AsPlainText -Force),
    [switch]        $run_on_cloud           = $false # if true, this script uses PS-Remoting and needs to be run from webserver, else it doesn't use PS-Remoting and should be run from a PowerShell prompt on RDP
)

# Set the execution policy to enable running Powershell modules and scripts
Set-ExecutionPolicy RemoteSigned -Force

# Helper function to download the PowerShell scripts from S3 buckets
function Get-PowerShellScript ($script_name, $script_url) {
    Write-Output "Downloading Powershell script $script_name from $script_url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($script_url, $script_name)
}

# Download utils PowerShell script with helper functions and import it, and download cloud-1.ps1
if (-not (Test-Path env:LOCAL)) { $env:LOCAL = 'no' }
if ($env:LOCAL -eq 'no')  {
    Write-Output "Downloading utils"
    $utils_script_name = "C:\utils.psm1"
    $utils_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.psm1"
    Get-PowerShellScript $utils_script_name $utils_script_url
} else {
    Write-Output "Running Local: LOCAL=$env:LOCAL"
    Get-Location
    $utils_script_name = "$PSScriptRoot/utils.psm1"
}

Import-Module "$utils_script_name"

# Make sure we're in the proper directory (mostly for running from webservers) and define credentials for user
Set-Location C:\
$credentials = New-Object System.Management.Automation.PSCredential $admin_username, $admin_password

# Run all the basic commands to setup a Fractal cloud computer
Update-Windows
Update-Firewall
Install-Chocolatey
Install-DotNetFramework
Install-DirectX
Install-VisualRedist
Install-VirtualAudio
Enable-Audio
Enable-RemotePowerShell $certificate_password # necessary for running run_on_cloud = $true scripts
Enable-MouseKeys $run_on_cloud $credentials
Set-MousePrecision $run_on_cloud $credentials
Disable-NetworkWindow
Install-7Zip
# Install-NvidiaTeslaPublicDrivers # Not installing, only using the Azure-installed GRID drivers for up to 4K resolution
Disable-TCC
Set-OptimalGPUSettings
Install-Curl
Install-PoshSSH
Show-FileExtensions $run_on_cloud $credentials
Set-FractalDirectory
Install-FractalWallpaper $run_on_cloud $credentials
Install-FractalServer $protocol_branch
Install-FractalService $protocol_branch
Install-FractalExitScript
Install-FractalAutoUpdate $protocol_branch
Enable-FractalFirewallRule
Install-Unison
Enable-SSHServer
Disable-UAC
Disable-Cursor
Disable-HyperV
Disable-Lock
Disable-Logout
Disable-Shutdown
# Add-AutoLogin $admin_username $admin_password # Ran standalone in the main-webserver after disk creation

# Clean PowerShell install script and restart
if ($env:LOCAL -eq 'no')  {
    Write-Output "Cleaning up Utils script script"
    Remove-Item -Path $utils_script_name -Confirm:$false -ErrorAction SilentlyContinue
    Restart-Computer -Force
}
