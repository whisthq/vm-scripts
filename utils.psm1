# This file contains the functions called in the PowerShell scripts
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$webClient = new-object System.Net.WebClient

function Update-Windows {
    $url = "https://gallery.technet.microsoft.com/scriptcenter/Execute-Windows-Update-fc6acb16/file/144365/1/PS_WinUpdate.zip"
    $compressed_file = "PS_WinUpdate.zip"
    $update_script = "PS_WinUpdate.ps1"

    Write-Output "Downloading Windows Update Powershell Script from $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$compressed_file")
    Unblock-File -Path "$PSScriptRoot\$compressed_file"

    Write-Output "Extracting Windows Update Powershell Script"
    Expand-Archive "$PSScriptRoot\$compressed_file" -DestinationPath "$PSScriptRoot\" -Force

    Write-Output "Running Windows Update"
    Invoke-Expression $PSScriptRoot\$update_script
}

function Update-Firewall {
    Write-Output "Enable ICMP Ping in Firewall"
    Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True
}

function Disable-TCC {
    $nvsmi = "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
    $gpu = & $nvsmi --format=csv,noheader --query-gpu=pci.bus_id
    & $nvsmi -g $gpu -fdm 0
}

function Enable-Audio {
    Write-Output "Enabling Audio Service"
    Set-Service -Name "Audiosrv" -StartupType Automatic
    Start-Service Audiosrv
}












function Install-VirtualAudio {
    $compressed_file = "VBCABLE_Driver_Pack43.zip"
    $driver_folder = "VBCABLE_Driver_Pack43"
    $driver_inf = "vbMmeCable64_win7.inf"
    $hardward_id = "VBAudioVACWDM"

    Write-Output "Downloading Virtual Audio Driver"
    $webClient.DownloadFile("http://vbaudio.jcedeveloppement.com/Download_CABLE/VBCABLE_Driver_Pack43.zip", "$PSScriptRoot\$compressed_file")
    Unblock-File -Path "$PSScriptRoot\$compressed_file"

    Write-Output "Extracting Virtual Audio Driver"
    Expand-Archive "$PSScriptRoot\$compressed_file" -DestinationPath "$PSScriptRoot\$driver_folder" -Force

    $wdk_installer = "wdksetup.exe"
    $devcon = "C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe"

    Write-Output "Downloading Windows Development Kit installer"
    $webClient.DownloadFile("http://go.microsoft.com/fwlink/p/?LinkId=526733", "$PSScriptRoot\$wdk_installer")

    Write-Output "Downloading and installing Windows Development Kit"
    Start-Process -FilePath "$PSScriptRoot\$wdk_installer" -ArgumentList "/S" -Wait

    $cert = "fractal-vb_certificate.cer"


    $url = "https://drive.google.com/file/d/15n1DxD0xKo-FrSiSK8y78iAXExqNDyUL/view?usp=sharing"




    Write-Output "Downloading VB certificate from $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$cert")

    Write-Output "Importing VB certificate"
    Import-Certificate -FilePath "$PSScriptRoot\$cert" -CertStoreLocation "cert:\LocalMachine\TrustedPublisher"

    Write-Output "Installing Virtual Audio Driver"
    Start-Process -FilePath $devcon -ArgumentList "install", "$PSScriptRoot\$driver_folder\$driver_inf", $hardward_id -Wait
}

function Install-Chocolatey {
    Write-Output "Installing Chocolatey"
    Invoke-Expression ($webClient.DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    chocolatey feature enable -n allowGlobalConfirmation
}













#Install-AdobeAcrobat

#Install-AdobePhotoshop
#Install-AdobeIllustrator
#Install-NvidiaGeForce

#Install-Blender
#Install-AutodeskMaya
#Install-ZBrush
#Install-AdobeAnimate
#Install-Cinema4D
#Install-3DSMaxDesign

#Install-AdobePremiere
#Install-DaVinciResolve
#Install-Blender
#Install-Lightworks


#Install-Office
#Install-Zoom
#Install-Skype
#Install-Anaconda
#Install-CudaToolkit
#Install-Pillow
#Install-OpenCV
#Install-Xgboost
#Install-Caffe

#Enable-DeveloperMode
#Install-VS2019
#Install-VSCode
#Install-WSL
#Install-Atom
#Install-Docker


#Install-GOG
#Install-Blizzard




## works 
function Install-Steam {
    $steam_exe = "steam.exe"
    Write-Output "Downloading Steam into path $PSScriptRoot\$steam_exe"
    $webClient.DownloadFile("https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe", "$PSScriptRoot\$steam_exe")
    Write-Output "Installing Steam"
    Start-Process -FilePath "$PSScriptRoot\$steam_exe" -ArgumentList "/S" -Wait

    Write-Output "Cleaning up Steam installation file"
    Remove-Item -Path $PSScriptRoot\$steam_exe -Confirm:$false
}

function Install-GoogleChrome {
    $chrome_msi = "googlechromestandaloneenterprise64.msi"
    Write-Output "Downloading Google Chrome into path $PSScriptRoot\$chrome_msi"
    $webClient.DownloadFile("https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi", "$PSScriptRoot\$chrome_msi")
    Write-Output "Installing Google Chrome"
    Start-Process -FilePath "$PSScriptRoot\$chrome_msi" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Google Chrome installation file"
    Remove-Item -Path $PSScriptRoot\$chrome_msi -Confirm:$false
}

function Install-EpicGamesLauncher {
    $epicgames_msi = "EpicInstaller-10.12.3-unrealtournament-94b142e24f5e49ffb002092313539737.msi"
    Write-Output "Downloading Epic Games Launcher into path $PSScriptRoot\$epicgames_msi"
    $webClient.DownloadFile("https://www.epicgames.com/unrealtournament/download", "$PSScriptRoot\$epicgames_msi")
    Write-Output "Installing Epic Games Launcher"
    Start-Process -FilePath "$PSScriptRoot\$epicgames_msi" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Epic Games Launcher installation file"
    Remove-Item -Path $PSScriptRoot\$epicgames_msi -Confirm:$false
}

function Install-Git {
    $git_exe = "Git-2.25.0-64-bit.exe"
    Write-Output "Downloading Git into path $PSScriptRoot\$git_exe"
    $webClient.DownloadFile("https://github.com/git-for-windows/git/releases/download/v2.25.0.windows.1/Git-2.25.0-64-bit.exe", "$PSScriptRoot\$git_exe")
    Write-Output "Installing Git"
    Start-Process -FilePath "$PSScriptRoot\$git_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Git installation file"
    Remove-Item -Path $PSScriptRoot\$git_exe -Confirm:$false
}
## end of works






function Install-Blender {
    $blender_msi = "blender-2.81a-windows64.msi"
    Write-Output "Downloading Blender into path $PSScriptRoot\$blender_msi"
    $webClient.DownloadFile("https://www.blender.org/download/", "$PSScriptRoot\$blender_msi")
    Write-Output "Installing Blender Launcher"
    Start-Process -FilePath "$PSScriptRoot\$blender_msi" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Blender installation file"
    Remove-Item -Path $PSScriptRoot\$blender_msi -Confirm:$false
}








function Install-GOG {
    $gog_exe = "GOG_Galaxy_2.0.exe"

    if (-not $PSScriptRoot) {
        $PSScriptRoot = Split-Path -Parent -Path $script:MyInvocation.MyCommand.Definition
    }
    $outFile = "$PSScriptRoot\GOG_Galaxy_2.0.exe"
    
    Write-Output "Downloading GOG into path $PSScriptRoot\$gog_exe"


    Start-BitsTransfer -Source $url -Destination $outFile

    
    
    

    Write-Output "Installing GOG"
    Start-Process -FilePath $outFile -Args "/qn" -Wait

#    Start-Process -FilePath "$PSScriptRoot\$gog_exe" -ArgumentList "/S" -Wait

    Write-Output "Cleaning up GOG installation file"
    Remove-Item -Path $PSScriptRoot\$gog_exe -Confirm:$false
}





function Install-Blizzard {
    $blizzard_exe = "Battle.net-Setup.exe"

    Write-Output "Downloading Blizzard Battle.Net Launcher into path $PSScriptRoot\$blizzard_exe"
    #$webClient.DownloadFile("https://www.google.com/search?q=install+blizzard&rlz=1C1CHBF_enUS880US880&oq=install+blizzard&aqs=chrome.0.0l8.1938j0j7&sourceid=chrome&ie=UTF-8", "$PSScriptRoot\$blizzard_exe")
   
   

    $webClient.DownloadFile("https://www.blizzard.com/en-us/apps/battle.net/desktop", "$PSScriptRoot\$blizzard_exe")

   
    Write-Output "Installing Blizzard Battle.Net Launcher"
    Start-Process -FilePath "$PSScriptRoot\$blizzard_exe" -ArgumentList "/S" -Wait

    Write-Output "Cleaning up Blizzard Battle.Net Launcher installation file"
    Remove-Item -Path $PSScriptRoot\$blizzard_exe -Confirm:$false











}
























function Set-Wallpaper {
    Write-Output "Setting Fractal Wallpaper"
    if((Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System) -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
    if((Test-RegistryValue -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -value Wallpaper) -eq $true) {Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name Wallpaper -value "C:\Program Files\Fractal\desktop.png" | Out-Null} Else {New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name Wallpaper -PropertyType String -value "C:\ParsecTemp\parsec+desktop.png" | Out-Null}
    if((Test-RegistryValue -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -value WallpaperStyle) -eq $true) {Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name WallpaperStyle -value 2 | Out-Null} Else {New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name WallpaperStyle -PropertyType String -value 2 | Out-Null}
    Stop-Process -ProcessName explorer
    }












function Add-AutoLogin ($admin_username, [SecureString] $admin_password) {
    Write-Output "Make the password and account of admin user never expire"
    Set-LocalUser -Name $admin_username -PasswordNeverExpires $true -AccountNeverExpires

    Write-Output "Make the admin login at startup"
    $registry = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $registry "AutoAdminLogon" -Value "1" -type String
    Set-ItemProperty $registry "DefaultDomainName" -Value "$env:computername" -type String
    Set-ItemProperty $registry "DefaultUsername" -Value $admin_username -type String
    Set-ItemProperty $registry "DefaultPassword" -Value $admin_password -type String
}
