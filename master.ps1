# This script should be run (as Administrator) first before any application-installer script
param (
    [string]        $admin_username = "Fractal",
    [SecureString]  $admin_password = (convertto-securestring "password1234567." -asplaintext -force),
    [switch]        $creative_install       = $false,
    [switch]        $datascience_install    = $false,
    [switch]        $gaming_install         = $false,
    [switch]        $productivity_install   = $false,
    [switch]        $softwaredev_install    = $false,
    [switch]        $engineering_install    = $false
)

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

# Run all the basic commands to setup a Fractal cloud computer
Update-Windows
Update-Firewall
Install-Chocolatey
Install-DotNetFramework # Requires a reboot otherwise dotnetfx will fail
Install-DirectX
Install-VisualRedist
Install-VirtualAudio
Enable-Audio
Enable-MouseKeys
Set-MousePrecision
Set-Time
Disable-NetworkWindow
Show-FileExtensions
Install-7Zip
Install-Spotify
Install-GoogleChrome
Install-NvidiaTeslaPublicDrivers
Disable-TCC
Set-OptimalGPUSettings
Set-FractalDirectory
Install-FractalService
Install-FractalServer
Install-FractalExitScript
Install-FractalAutoUpdate
Install-FractalWallpaper
Enable-FractalFirewallRule
#Disable-HyperV
#Disable-Lock
#Disable-Logout
#Disable-Shutdown
Add-AutoLogin $admin_username $admin_password

# Install creative packages
if ($creative_install) {
    # fetch the script, run it and clean
    Write-Output "Launching Creative Install script"
    $creative_script_name = "C:\creative.ps1"
    $creative_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/creative.ps1"
    GetPowerShellScript $creative_script_name $creative_script_url
    Start-Process powershell.exe -verb RunAs -argument "-file $creative_script_name" -Wait
    Write-Output "Cleaning up Creative Install script"
    Remove-Item -Path $creative_script_name -Confirm:$false
}

# Install data science packages
if ($datascience_install) {
    # fetch the script, run it and clean
    Write-Output "Launching Data Science Install script"
    $datascience_script_name = "C:\datascience.ps1"
    $datascience_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/datascience.ps1"
    GetPowerShellScript $datascience_script_name $datascience_script_url
    Start-Process powershell.exe -verb RunAs -argument "-file $datascience_script_name" -Wait
    Write-Output "Cleaning up Data Science Install script"
    Remove-Item -Path $datascience_script_name -Confirm:$false
}

# Install gaming packages
if ($gaming_install) {
    # fetch the script, run it and clean
    Write-Output "Launching Gaming Install script"
    $gaming_script_name = "C:\gaming.ps1"
    $gaming_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/gaming.ps1"
    GetPowerShellScript $gaming_script_name $gaming_script_url
    Start-Process powershell.exe -verb RunAs -argument "-file $gaming_script_name" -Wait
    Write-Output "Cleaning up Gaming Install script"
    Remove-Item -Path $gaming_script_name -Confirm:$false
}

# Install software development packages
if ($softwaredev_install) {
    # fetch the script, run it and clean
    Write-Output "Launching Software Development Install script"
    $softwaredev_script_name = "C:\softwaredev.ps1"
    $softwaredev_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/softwaredev.ps1"
    GetPowerShellScript $softwaredev_script_name $softwaredev_script_url
    Start-Process powershell.exe -verb RunAs -argument "-file $softwaredev_script_name" -Wait
    Write-Output "Cleaning up Software Development Install script"
    Remove-Item -Path $softwaredev_script_name -Confirm:$false
}

# Install engineering packages
if ($engineering_install) {
    # fetch the script, run it and clean
    Write-Output "Launching Engineering Install script"
    $engineering_script_name = "C:\engineering.ps1"
    $engineering_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/engineering.ps1"
    GetPowerShellScript $engineering_script_name $engineering_script_url
    Start-Process powershell.exe -verb RunAs -argument "-file $engineering_script_name" -Wait
    Write-Output "Cleaning up Engineering Install script"
    Remove-Item -Path $engineering_script_name -Confirm:$false
}

# Install productivity packages
if ($productivity_install) {
    # fetch the script, run it and clean
    Write-Output "Launching Productivity Install script"
    $productivity_script_name = "C:\productivity.ps1"
    $productivity_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/productivity.ps1"
    GetPowerShellScript $productivity_script_name $productivity_script_url
    Start-Process powershell.exe -verb RunAs -argument "-file $productivity_script_name" -Wait
    Write-Output "Cleaning up Productivity Install script"
    Remove-Item -Path $productivity_script_name -Confirm:$false
}

# Clean PowerShell install script
Write-Output "Cleaning up Utils script"
Remove-Item -Path $utils_script_name -Confirm:$false

Restart-Computer
