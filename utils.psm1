# This file contains the functions called in the PowerShell scripts
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$webClient = new-object System.Net.WebClient

function Test-RegistryValue {
    # https://www.jonathanmedd.net/2014/02/testing-for-the-presence-of-a-registry-key-and-value.html
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Value
    )
    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}
    
function Update-Windows {
    $url = "https://gallery.technet.microsoft.com/scriptcenter/Execute-Windows-Update-fc6acb16/file/144365/1/PS_WinUpdate.zip"
    $compressed_file = "PS_WinUpdate.zip"
    $update_script = "PS_WinUpdate.ps1"

    Write-Output "Downloading Windows Update Powershell Script from $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$compressed_file")
    Unblock-File -Path "$PSScriptRoot\$compressed_file" -Force

    Write-Output "Extracting Windows Update Powershell Script"
    Expand-Archive "$PSScriptRoot\$compressed_file" -DestinationPath "$PSScriptRoot\" -Force

    Write-Output "Running Windows Update"
    Invoke-Expression $PSScriptRoot\$update_script -Force

    Write-Output "Cleaning up Windows Update installation files"
    Remove-Item -Path $PSScriptRoot\$update_script -Confirm:$false
    Remove-Item -Path $PSScriptRoot\$compressed_file -Confirm:$false
    Remove-Item -Path "C:\TestServ01_Report.txt" -Confirm:$false
    Remove-Item -Path "C:\Users\Fractal\$($env:COMPUTERNAME)_Report.txt" -Confirm:$false
}

function Update-Firewall {
    Write-Output "Enable ICMP Ping in Firewall"
    Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True -Force
}

function Disable-TCC {
    Write-Output "Disable TCC Mode on Nvidia Tesla GPU"
    $nvsmi = "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
    $gpu = & $nvsmi --format=csv,noheader --query-gpu=pci.bus_id
    & $nvsmi -g $gpu -fdm 0
}

function Add-AutoLogin ($admin_username, [SecureString] $admin_password) {
    Write-Output "Make the password and account of admin user never expire"
    Set-LocalUser -Name $admin_username -PasswordNeverExpires $true -AccountNeverExpires -Force

    Write-Output "Make the admin login at startup"
    $registry = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $registry "AutoAdminLogon" -Value "1" -type String -Force
    Set-ItemProperty $registry "DefaultDomainName" -Value "$env:computername" -type String -Force
    Set-ItemProperty $registry "DefaultUsername" -Value $admin_username -type String -Force
    Set-ItemProperty $registry "DefaultPassword" -Value $admin_password -type String -Force
}

function Install-FractalWallpaper {
    # first download the wallpaper
    Write-Output "Downloading Fractal Wallpaper"
    $fractalwallpaper_name = "C:\Program Files\Fractal\Assets\wallpaper.png"
    $fractalwallpaper_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/wallpaper.png"
    $webClient.DownloadFile($fractalwallpaper_url, $fractalwallpaper_name)

    # then set the wallpaper
    Write-Output "Setting Fractal Wallpaper"
    if((Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System) -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" -Force | Out-Null}
    if((Test-RegistryValue -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -value Wallpaper) -eq $true) {Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name Wallpaper -value "C:\Program Files\Fractal\Assets\wallpaper.png" -Force | Out-Null} Else {New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name Wallpaper -PropertyType String -value "C:\Program Files\Fractal\Assets\wallpaper.png" -Force | Out-Null}
    if((Test-RegistryValue -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -value WallpaperStyle) -eq $true) {Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name WallpaperStyle -value 2 -Force | Out-Null} Else {New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name WallpaperStyle -PropertyType String -value 2 -Force | Out-Null}
}

function Install-FractalService {
    # first download the service executable
    Write-Output "Downloading Fractal Service"
    $fractalservice_name = "C:\Program Files\Fractal\FractalService.exe"
    $fractalservice_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/FractalService.exe"
    $webClient.DownloadFile($fractalservice_url, $fractalservice_name)

    # then install the service
    Write-Output "Enabling Fractal Service"
    cmd.exe /c 'sc.exe Create "Fractal" binPath= "\"C:\Program Files\Fractal\FractalService.exe\"" start= "auto"' | Out-Null
    cmd.exe /c 'sc.exe description "Fractal" "Fractal Service"' | Out-Null
    sc.exe Start 'Fractal' | Out-Null
}

function Enable-FractalFirewallRule {
    Write-host "Creating Fractal Firewall Rule"
    New-NetFirewallRule -DisplayName "Fractal" -Direction Inbound -Program "C:\Program Files\Fractal\FractalServer.exe" -Profile Private, Public -Action Allow -Enabled True -Force | Out-Null
}

function Enable-DeveloperMode {
    Write-Output "Enabling Windows Developer Mode"
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
}

function Enable-Audio {
    Write-Output "Enabling Audio Service"
    Set-Service -Name "Audiosrv" -StartupType Automatic -Force
    Start-Service Audiosrv -Force
}

function Install-VirtualAudio {
    $compressed_file = "VBCABLE_Driver_Pack43.zip"
    $driver_folder = "VBCABLE_Driver_Pack43"
    $driver_inf = "vbMmeCable64_win7.inf"
    $hardware_id = "VBAudioVACWDM"

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
    Start-Process -FilePath "$PSScriptRoot\$wdk_installer" -ArgumentList "/S" -Wait -Force

    $cert = "vb_cert.cer"
    $url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/vb_cert.cer"

    Write-Output "Downloading VB certificate from $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$cert")

    Write-Output "Importing VB certificate"
    Import-Certificate -FilePath "$PSScriptRoot\$cert" -CertStoreLocation "cert:\LocalMachine\TrustedPublisher" -Force

    Write-Output "Installing Virtual Audio Driver"
    Start-Process -FilePath $devcon -ArgumentList "install", "$PSScriptRoot\$driver_folder\$driver_inf", $hardware_id -Wait -Force

    Write-Output "Cleaning up Virtual Audio Driver installation files"
    Remove-Item -Path $PSScriptRoot\$driver_folder -Confirm:$false -Recurse
    Remove-Item -Path $PSScriptRoot\$wdk_installer -Confirm:$false
    Remove-Item -Path $PSScriptRoot\$compressed_file -Confirm:$false
    Remove-Item -Path $PSScriptRoot\$cert -Confirm:$false

    Write-Output "Removing WDK Desktop shortcuts"
    Remove-Item -Path "C:\Users\Public\Desktop\Windows TShell.lnk" -Confirm:$false
    Remove-Item -Path "C:\Users\Public\Desktop\WPCups.lnk" -Confirm:$false
}

function Install-Chocolatey {
    Write-Output "Installing Chocolatey"
    Invoke-Expression ($webClient.DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    chocolatey feature enable -n allowGlobalConfirmation
}

function Install-Steam {
    Write-Output 'Installing Steam through Chrocolatey'
    choco install steam --force
}

function Install-Discord {
    Write-Output "Installing Discord through Chocolatey"
    choco install discord --force
}

function Install-GoogleChrome {
    Write-Output 'Installing Google Chrome through Chrocolatey'
    choco install googlechrome --force --ignore-checksums
}

function Install-EpicGamesLauncher {
    Write-Output 'Installing Epic Games Launcher through Chrocolatey'
    choco install epicgameslauncher --force
}

function Install-Blizzard {
    $blizzard_exe = "Battle.net-Setup.exe"
    Write-Output "Downloading Blizzard Battle.Net Launcher into path $PSScriptRoot\$blizzard_exe"
    $webClient.DownloadFile("https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP&id=634826696.1580926426", "$PSScriptRoot\$blizzard_exe")    
    Write-Output "Installing Blizzard Battle.Net Launcher"
    Start-Process -FilePath "$PSScriptRoot\$blizzard_exe" -ArgumentList "/q" -Wait -Force

    Write-Output "Cleaning up Blizzard Battle.Net Launcher installation file"
    Remove-Item -Path $PSScriptRoot\$blizzard_exe -Confirm:$false
}

function Install-Git {
    Write-Output "Installing Git through Chocolatey"
    choco install git --force
}

function Install-OpenCV {
    Write-Output "Installing OpenCV through Chocolatey"
    choco install opencv --force
}

function Install-Blender {
    Write-Output "Installing Blender through Chocolatey"
    choco install blender --force
}

function Install-AdobeAcrobat {
    Write-Output "Installing Adobe Acrobat Reader DC through Chocolatey"
    choco install adobereader --force
}

function Install-Skype {
    Write-Output "Installing Skype through Chocolatey"
    choco install skype --force
}

function Install-AdobeCreativeCloud {
    # Not downloadable without a Adobe subscription
}

function Install-DaVinciResolve {
    # Not downloadable without a DaVinci Resolve subscription
}

function Install-ZBrush {
    # Not downloadable without a ZBrush subscription
}

function Install-AutodeskMaya {
    # Not downloadable without an Autodesk subscription
}

function Install-3DSMaxDesign {
    # Not downloadable without an Autodesk subscription
}

function Install-Solidworks {
    # Not downloadable without a Dassault Systemes subscription
}

function Install-Matlab {
    # Not downloadable without a Mathworks subscription
}

function Install-Zoom {
    Write-Output "Installing Zoom through Chocolatey"
    choco install zoom --force
}

function Install-Office {
    Write-Output "Installing Microsoft Office Suite through Chocolatey"
    choco install microsoft-office-deployment --force
}

function Install-Anaconda {
    Write-Output "Installing Anaconda (Python 3) through Chocolatey"
    choco install anaconda3 --force
}

function Install-Docker {
    Write-Output "Installing Docker through Chocolatey"
    choco install docker --force
}

function Install-Atom {
    Write-Output "Installing Atom through Chocolatey"
    choco install atom --force
}

function Install-Cinema4D {
    Write-Output "Installing Cinema4D through Chocolatey"
    choco install cinebench --force
}

function Install-GeForceExperience {
    Write-Output "Installing Nvidia GeForce Experience through Chocolatey"
    choco install geforce-experience --force
}

function Install-Lightworks {
    Write-Output "Installing Lightworks through Chocolatey"
    choco install lightworks --force
}

function Install-VSPro2019 {
    Write-Output "Installing Visual Studio Professional 2019 through Chocolatey"
    choco install visualstudio2019professional --force
}

function Install-VisualRedist {
    Write-Output "Installing Visual C++ Redistribuable 2017 through Chocolatey"
    choco install vcredist2017 --force
}

function Install-VSCode {
    Write-Output "Installing Visual Studio Code through Chocolatey"
    choco install vscode --force
}

function Install-Fusion360 {
    Write-Output "Installing Autodesk Fusion360 through Chocolatey"
    choco install autodesk-fusion360 --force
}

function Install-Spotify {
    Write-Output "Installing Spotify through Chocolatey"
    choco install spotify --force
}

function Install-GOG {
    Write-Output "Installing GOG through Chocolatey"
    choco install goggalaxy --force
}

function Install-7Zip {
    Write-Output "Installing 7-Zip through Chocolatey"
    choco install 7zip --force
}

function Install-Slack {
    Write-Output "Installing Slack through Chocolatey"
    choco install slack --force
}

function Install-WSL {
    Write-Output "Installing Windows Subsystem for Linux through Chocolatey"
    choco install wsl --force
}

function Set-Time {
    Write-Output "Setting Time & Timezone to Automatic"
    Set-ItemProperty -path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name Type -Value NTP -Force | Out-Null
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate -Name Start -Value 00000003 -Froce | Out-Null
}

function Disable-NetworkWindow {
    Write-Output "Disabling New Network Window"
    if((Test-RegistryValue -path HKLM:\SYSTEM\CurrentControlSet\Control\Network -Value NewNetworkWindowOff) -eq $true) {} Else {new-itemproperty -path HKLM:\SYSTEM\CurrentControlSet\Control\Network -name "NewNetworkWindowOff" -Force | Out-Null}
}

function Set-MousePrecision {
    Write-Output "Enabling Enhanced Pointer Precision"
    Set-Itemproperty -Path 'HKCU:\Control Panel\Mouse' -Name MouseSpeed -Value 1 -Force | Out-Null
}
    
function Enable-MouseKeys {
    Write-Output "Enabling Mouse Keys"
    set-Itemproperty -Path 'HKCU:\Control Panel\Accessibility\MouseKeys' -Name Flags -Value 63 -Force | Out-Null
}

function Disable-Logout {
    Write-Output "Disabling Logout Option in Start Menu"
    if((Test-RegistryValue -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Value StartMenuLogOff) -eq $true) {Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name StartMenuLogOff -Value 1 -Force | Out-Null} Else {New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name StartMenuLogOff -Value 1 -Force | Out-Null}
}
    
function Disable-Lock {
    Write-Output "Disable Lock Option in Start Menu"
    if((Test-Path -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System) -eq $true) {} Else {New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies -Name Software -Force | Out-Null}
    if((Test-RegistryValue -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Value DisableLockWorkstation) -eq $true) {Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name DisableLockWorkstation -Value 1 -Force | Out-Null } Else {New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name DisableLockWorkstation -Value 1 -Force | Out-Null}
}

function Disable-Shutdown {
    Write-Output "Disabling Shutdown Option in Start Menu"
    New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name NoClose -Value 1 -Force | Out-Null
}
    
function Show-FileExtensions {
    Write-Output "Showing File Extensions"
    Set-itemproperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name HideFileExt -Value 0 -Force | Out-Null
}
  
function Set-FractalDirectory {
    Write-Output "Creating Fractal Directory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal' -ItemType directory | Out-Null}

    Write-Output "Creating Fractal Asset Subdirectory in C:\Program Files\Fractal"
    if((Test-Path -Path 'C:\Program Files\Fractal\Assets') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal\Assets' -ItemType directory | Out-Null}

    Write-Output "Creating Fractal Exit Subdirectory in C:\Program Files\Fractal"
    if((Test-Path -Path 'C:\Program Files\Fractal\Exit') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal\Exit' -ItemType directory | Out-Null}

    Write-Output "Creating Fractal Sync Subdirectory in C:\Program Files\Fractal"
    if((Test-Path -Path 'C:\Program Files\Fractal\Sync') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal\Sync' -ItemType directory | Out-Null}
}

function Install-DotNetFramework {
    Write-Output "Installing .Net Framework Core 4.8 through Chocolatey"
    choco install dotnetfx --force
}

function Disable-HyperV {
    $url = "https://gallery.technet.microsoft.com/PowerShell-Device-60d73bb0/file/147248/2/DeviceManagement.zip"
    $compressed_file = "DeviceManagement.zip"
    $extract_folder = "DeviceManagement"

    Write-Output "Downloading Device Management Powershell Script from $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$compressed_file")
    Unblock-File -Path "$PSScriptRoot\$compressed_file" -Force

    Write-Output "Extracting Device Management Powershell Script"
    Expand-Archive "$PSScriptRoot\$compressed_file" -DestinationPath "$PSScriptRoot\$extract_folder" -Force

    Write-Output "Disabling Hyper-V Video"
    Import-Module "$PSScriptRoot\$extract_folder\DeviceManagement.psd1"
    Get-Device | Where-Object -Property Name -Like "Microsoft Hyper-V Video" -Force | Disable-Device -Confirm:$false

    Write-Output "Cleaning up Hyper-V Video disabling file"
    Remove-Item -Path $PSScriptRoot\$compressed_file -Confirm:$false
    Remove-Item -Path $PSScriptRoot\$extract_folder -Confirm:$false -Recurse
}

function Install-FractalServer {
    # only download, server will get started by service
    Write-Output "Downloading Fractal Server"
    $fractalserver_name = "C:\Program Files\Fractal\FractalServer.exe"
    $fractalserver_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/FractalServer.exe"
    $webClient.DownloadFile($fractalserver_url, $fractalserver_name)

    # download the .dlls
    Write-Output "Downloading FFmpeg DLLs"
    $avcodec_name = "C:\Program Files\Fractal\avcodec-58.dll"
    $avcodec_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/avcodec-58.dll"
    $webClient.DownloadFile($avcodec_url, $avcodec_name)

    $avdevice_name = "C:\Program Files\Fractal\avdevice-58.dll"
    $avdevice_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/avdevice-58.dll"
    $webClient.DownloadFile($avdevice_url, $avdevice_name)

    $avfilter_name = "C:\Program Files\Fractal\avfilter-7.dll"
    $avfilter_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/avfilter-7.dll"
    $webClient.DownloadFile($avfilter_url, $avfilter_name)

    $avformat_name = "C:\Program Files\Fractal\avformat-58.dll"
    $avformat_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/avformat-58.dll"
    $webClient.DownloadFile($avformat_url, $avformat_name)

    $avutil_name = "C:\Program Files\Fractal\avutil-56.dll"
    $avutil_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/avutil-56.dll"
    $webClient.DownloadFile($avutil_url, $avutil_name)

    $postproc_name = "C:\Program Files\Fractal\postproc-55.dll"
    $postproc_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/postproc-55.dll"
    $webClient.DownloadFile($postproc_url, $postproc_name)

    $swresample_name = "C:\Program Files\Fractal\swresample-3.dll"
    $swresample_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/swresample-3.dll"
    $webClient.DownloadFile($swresample_url, $swresample_name)

    $swscale_name = "C:\Program Files\Fractal\swscale-5.dll"
    $swscale_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/swscale-5.dll"
    $webClient.DownloadFile($swscale_url, $swscale_name)
}

function Install-FractalAutoUpdate {
    # no need to download version, update.bat will download it
    Write-Output "Downloading Fractal Auto Update script"
    $fractal_update_name = "C:\Program Files\Fractal\update.bat"
    $fractal_update_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/update.bat"
    $webClient.DownloadFile($fractal_update_url, $fractal_update_name)
}

function Install-FractalExitScript {
    # only download, gets called by the vbs file
    Write-Output "Downloading Fractal Exit script"
    $fractal_exitbat_name = "C:\Program Files\Fractal\Exit\ExitFractal.bat"
    $fractal_exitbat_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/ExitFractal.bat"
    $webClient.DownloadFile($fractal_exitbat_url, $fractal_exitbat_name)

    # download vbs file for running .bat file without terminal
    Write-Output "Downloading Fractal Exit VBS helper script"
    $fractal_exitvbs_name = "C:\Program Files\Fractal\Exit\Exit.vbs"
    $fractal_exitvbs_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/Exit.vbs"
    $webClient.DownloadFile($fractal_exitvbs_url, $fractal_exitvbs_name)

    # download the Fractal logo for the icons
    Write-Output "Downloading Fractal Logo icon"
    $fractal_icon_name = "C:\Program Files\Fractal\Assets\logo.ico"
    $fractal_icon_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/logo.ico"
    $webClient.DownloadFile($fractal_icon_url, $fractal_icon_name)

    # create desktop shortcut
    Write-Output "Creating Exit Fractal Desktop Shortcut"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Exit Fractal.lnk")
    $Shortcut.TargetPath = "C:\Program Files\Fractal\Exit\Exit.vbs"
    $Shortcut.IconLocation="C:\Program Files\Fractal\Assets\logo.ico"
    $Shortcut.Save()

    # create start menu shortcut
    Write-Output "Creating Exit Fractal Start Menu Shortcut"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_Exit Fractal_.lnk")
    $Shortcut.TargetPath = "C:\Program Files\Fractal\Exit\Exit.vbs"
    $Shortcut.IconLocation="C:\Program Files\Fractal\Assets\logo.ico"
    $Shortcut.Save()
}

function Install-NvidiaTeslaPublicDrivers {
    Write-Output "Installing Nvidia Public Driver (GRID already installed at deployment through Azure)"
    $driver_file = "441.22-tesla-desktop-win10-64bit-international.exe"
    $version = "441.22"
    $url = "http://us.download.nvidia.com/tesla/441.22/441.22-tesla-desktop-win10-64bit-international.exe"
    
    Write-Output "Downloading Nvidia M60 driver from URL $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$driver_file")

    Write-Output "Installing Nvidia M60 driver from file $driver_file"
    Start-Process -FilePath "$PSScriptRoot\$driver_file" -ArgumentList "-s", "-noreboot" -Wait -Force

    Write-Output "Cleaning up Nvidia Public Drivers installation file"
    Remove-Item -Path "$PSScriptRoot\$driver_file" -Confirm:$false
}

function Set-OptimalGPUSettings {
    Write-Output "Setting Optimal Tesla M60 GPU Settings"
    C:\'Program Files'\'NVIDIA Corporation'\NVSMI\.\nvidia-smi --auto-boost-default=0
    C:\'Program Files'\'NVIDIA Corporation'\NVSMI\.\nvidia-smi -ac "2505,1177"
}

function Install-DirectX {
    $directx_exe = "directx_Jun2010_redist.exe"
    Write-Output "Downloading DirectX into path $PSScriptRoot\$direct_exe"
    $webClient.DownloadFile("https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe", "$PSScriptRoot\$directx_exe")
    
    Write-Output "Creating temporary DirectX directory in $PSScriptRoot/"
    if((Test-Path -Path '/DirectX') -eq $true) {} Else {New-Item -Path '/DirectX' -ItemType directory | Out-Null}

    Write-Output "Installing DirectX"
    Start-Process -FilePath "$PSScriptRoot\$directx_exe" "/T:$PSScriptRoot/DirectX /Q" -Wait

    Write-Output "Cleaning up DirectX installation file"
    Remove-Item -Path $PSScriptRoot\$directx_exe -Confirm:$false
    Remove-Item -Path $PSScriptRoot\DirectX -Confirm:$false -Recurse
}

function Install-Unison {
    Write-Output "Downloading Unsion Fily Sync from S3 Bucket" 
    $unison_name = "C:\Program Files\Fractal\Sync\unison.exe"
    $unison_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/unison.exe"
    $webClient.DownloadFile($unison_url, $unison_name)
}

function Enable-SSHServer {
    Write-Output "Adding OpenSSH Server Capability"
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -Force
    if (-not $?) {
        Write-Output "Add-WindowsCapability Failed, Trying DISM"
        dism /online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
        # both failed, need to contact support
        if (-not $?) {
            Write-Output "OpenSSH Server Failed to Install -- Contact support@fractalcomputers.com for Help"
        }
    }

    Write-Output "Downloading new OpenSSH Server Config"     
    $webClient.DownloadFile("https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/ssh_config", "$env:ProgramData\ssh\sshd_config")
        
    Write-Output "Generate SSH Key"     
    ssh-keygen -f sshkey -q -N """"
    copy sshkey.pub $env:ProgramData\ssh\administrators_authorized_keys

    Write-Output "Remove Inheritance and All Authorized Users for the Authorized Keys"
    icacls $env:ProgramData\ssh\administrators_authorized_keys /inheritance:r
    icacls $env:ProgramData\ssh\administrators_authorized_keys /remove:g "Authorized Users" # apparently necessary to remove Authorized Users from file permissions, unclear if this works/is needed

    Write-Output "Start the SSH Server"
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'
    Get-NetFirewallRule -Name *ssh* # didn't seem needed, but just in case
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 # didn't seem needed, but just in case

    Write-Output "Add Unison Executable Path"
    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\Program Files\Fractal\Sync", [EnvironmentVariableTarget]::Machine)
}
