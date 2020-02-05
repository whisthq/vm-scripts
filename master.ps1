# This script should be run (as Administrator) first before any application-installer script
# TODO: change password to secure password
param (
    [string]        $admin_username = "Fractal",
    [SecureString]  $admin_password = (convertto-securestring "password1234567." -asplaintext -force),
    [switch]        $manual_install         = $false,
    [switch]        $creative_install       = $false,
    [switch]        $datascience_install    = $false,
    [switch]        $gaming_install         = $false,
    [switch]        $productivity_install   = $false,
    [switch]        $softwaredev_install    = $false
)

# Helper function to download the PowerShell scripts from S3 buckets
function GetPowershellScript ($script_name, $script_url) {
    Write-Host "Downloading Powershell script $script_name from $script_url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile($url, "C:\$script_name")
}

# TODO: Change to fixed path & get the file downloaded on VM
$script_name = "C:\users\phili\Downloads\fractal-setup-scripts\utils.psm1"
Import-Module "$script_name"

#Update-Windows
#Update-Firewall
#Disable-TCC
#Enable-Audio
#Install-VirtualAudio
#Install-Chocolatey
#Install-GoogleChrome






#Set-Wallpaper

#Install-AutodeskMaya
#Install-ZBrush
#Install-3DSMaxDesign
#Install-Lightworks
#Install-CudaToolkit
#Enable-DeveloperMode
#Install-VS2019
#Install-VSCode
#Install-WSL
#Install-Spotify
#Install-GOG
#Install-Blizzard

#Disable-ScheduleWorkflow
#Disable-Devices


#- Set Automatic Time & Timezone
#- Install Spotify
#- Install Tesla Nvidia Public Drivers
#- Install 7zip
#- Install DirectX
#- Install .Net Framework (>3.5)
#- Install Fractal
#- Set Fractal Wallpaper











if ($creative_install) {
    # fetch the script, run it and clean
    GetPowershellScript("creative.ps1", "TODO")
    Start-Process powershell.exe -verb RunAs -argument "-file C:\creative.ps1" -Wait
    Write-Output "Cleaning up Creative Install script"
    Remove-Item -Path "C:\creative.ps1" -Confirm:$false
}

if ($datascience_install) {
    # fetch the script, run it and clean
    GetPowershellScript("datascience.ps1", "TODO")
    Start-Process powershell.exe -verb RunAs -argument "-file C:\datascience.ps1" -Wait
    Write-Output "Cleaning up Data Science Install script"
    Remove-Item -Path "C:\datascience.ps1" -Confirm:$false
}

if ($gaming_install) {
    # fetch the script, run it and clean
    GetPowershellScript("gaming.ps1", "TODO")
    Start-Process powershell.exe -verb RunAs -argument "-file C:\gaming.ps1" -Wait
    Write-Output "Cleaning up Gaming Install script"
    Remove-Item -Path "C:\gaming.ps1" -Confirm:$false
}

if ($softwaredev_install) {
    # fetch the script, run it and clean
    GetPowershellScript("softwaredev.ps1", "TODO")
    Start-Process powershell.exe -verb RunAs -argument "-file C:\softwaredev.ps1" -Wait
    Write-Output "Cleaning up Software Development Install script"
    Remove-Item -Path "C:\softwaredev.ps1" -Confirm:$false
}

if ($productivity_install) {
    # fetch the script, run it and clean
    GetPowershellScript("productivity.ps1", "TODO")
    Start-Process powershell.exe -verb RunAs -argument "-file C:\productivity.ps1" -Wait
    Write-Output "Cleaning up Productivity Install script"
    Remove-Item -Path "C:\productivity.ps1" -Confirm:$false
}

# Final file cleaning
#Write-Output "Cleaning up Utils script"
#Remove-Item -Path "C:\utils.psm1" -Confirm:$false

#Add-AutoLogin $admin_username $admin_password
##Restart-Computer