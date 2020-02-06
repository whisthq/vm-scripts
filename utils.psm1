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

function Set-Wallpaper {
    Write-Output "Setting Fractal Wallpaper"
    if((Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System) -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
    if((Test-RegistryValue -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -value Wallpaper) -eq $true) {Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name Wallpaper -value "C:\Program Files\Fractal\desktop.png" | Out-Null} Else {New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name Wallpaper -PropertyType String -value "C:\Program Files\Fractal\desktop.png" | Out-Null}
    if((Test-RegistryValue -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -value WallpaperStyle) -eq $true) {Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name WallpaperStyle -value 2 | Out-Null} Else {New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name WallpaperStyle -PropertyType String -value 2 | Out-Null}
    Stop-Process -ProcessName explorer
}

function Enable-FractalService {
    Write-host "Enabling Fractal Service"
    cmd.exe /c 'sc.exe Create "Fractal" binPath= "\"C:\Program Files\Fractal\FractalService.exe\"" start= "auto"' | Out-Null
    sc.exe Start 'Fractal' | Out-Null
}

function Enable-FractalFirewallRule {
    Write-host "Creating Fractal Firewall Rule"
    New-NetFirewallRule -DisplayName "Fractal" -Direction Inbound -Program "C:\Program Files\Fractal\Fractal.exe" -Profile Private, Public -Action Allow -Enabled True | Out-Null
}

function Enable-DeveloperMode {
    Write-Output "Enabling Windows Developer Mode"
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
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

    $cert = "vb_cert.cer"
    $url = "https://fractal-audiodriver-certificate.s3.amazonaws.com/vb_cert.cer"

    Write-Output "Downloading VB certificate from $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$cert")

    Write-Output "Importing VB certificate"
    Import-Certificate -FilePath "$PSScriptRoot\$cert" -CertStoreLocation "cert:\LocalMachine\TrustedPublisher"

    Write-Output "Installing Virtual Audio Driver"
    Start-Process -FilePath $devcon -ArgumentList "install", "$PSScriptRoot\$driver_folder\$driver_inf", $hardward_id -Wait

    Write-Output "Cleaning up Virtual Audio Driver installation files"
    Remove-Item -Path $PSScriptRoot\$driver_folder -Confirm:$false -Recurse
    Remove-Item -Path $PSScriptRoot\$wdk_installer -Confirm:$false
}

function Install-Chocolatey {
    Write-Output "Installing Chocolatey"
    Invoke-Expression ($webClient.DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    chocolatey feature enable -n allowGlobalConfirmation
}

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

function Install-Blizzard {
    $blizzard_exe = "Battle.net-Setup.exe"
    Write-Output "Downloading Blizzard Battle.Net Launcher into path $PSScriptRoot\$blizzard_exe"
    $webClient.DownloadFile("https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP&id=634826696.1580926426", "$PSScriptRoot\$blizzard_exe")    
    Write-Output "Installing Blizzard Battle.Net Launcher"
    Start-Process -FilePath "$PSScriptRoot\$blizzard_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Blizzard Battle.Net Launcher installation file"
    Remove-Item -Path $PSScriptRoot\$blizzard_exe -Confirm:$false
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

function Install-OpenCV {
    $opencv_exe = "opencv-4.2.0-vc14_vc15.exe"
    Write-Output "Downloading OpenCV into path $PSScriptRoot\$opencv_exe"
    $webClient.DownloadFile("https://sourceforge.net/projects/opencvlibrary/files/latest/download", "$PSScriptRoot\$opencv_exe")
    Write-Output "Installing OpenCV"
    Start-Process -FilePath "$PSScriptRoot\$opencv_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up OpenCV installation file"
    Remove-Item -Path $PSScriptRoot\$opencv_exe -Confirm:$false
}

function Install-Blender {
    $blender_msi = "blender-2.81a-windows64.msi"
    Write-Output "Downloading Blender into path $PSScriptRoot\$blender_msi"
    $webClient.DownloadFile("https://www.blender.org/download/Blender2.81/blender-2.81a-windows64.msi/", "$PSScriptRoot\$blender_msi")
    Write-Output "Installing Blender"
    Start-Process -FilePath "$PSScriptRoot\$blender_msi" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Blender installation file"
    Remove-Item -Path $PSScriptRoot\$blender_msi -Confirm:$false
}

function Install-AdobeAcrobat {
    $acrobat_exe = "readerdc_en_xa_cra_install.exe"
    Write-Output "Downloading Adobe Acrobat Reader into path $PSScriptRoot\$acrobat_exe"
    $webClient.DownloadFile("https://get.adobe.com/reader/download/?installer=Reader_DC_2019.021.20058_English_for_Windows&os=Windows%2010&browser_type=KHTML&browser_dist=Chrome&dualoffer=false&mdualoffer=true&cr=true&stype=7468&d=McAfee_Security_Scan_Plus&d=McAfee_Safe_Connect/", "$PSScriptRoot\$acrobat_exe")
    Write-Output "Installing Adobe Acrobat Reader"
    Start-Process -FilePath "$PSScriptRoot\$acrobat_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Adobe Acrobat Reader installation file"
    Remove-Item -Path $PSScriptRoot\$acrobat_exe -Confirm:$false
}

function Install-Skype {
    $skype_exe = "Skype-8.56.0.103.exe"
    Write-Output "Downloading Skype into path $PSScriptRoot\$skype_exe"
    $webClient.DownloadFile("https://go.skype.com/windows.desktop.download", "$PSScriptRoot\$skype_exe")
    Write-Output "Installing Skype"
    Start-Process -FilePath "$PSScriptRoot\$skype_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Skype installation file"
    Remove-Item -Path $PSScriptRoot\$skype_exe -Confirm:$false
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

function Install-Zoom {
    # Not downloadable without a Zoom account
}

function Install-Office {
    # Not downloadable without a Microsoft account
}

function Install-Anaconda {
    $anaconda_exe = "Anaconda3-2019.10-Windows-x86_64.exe"
    Write-Output "Downloading Anaconda into path $PSScriptRoot\$anaconda_exe"
    $webClient.DownloadFile("https://repo.anaconda.com/archive/Anaconda3-2019.10-Windows-x86_64.exe", "$PSScriptRoot\$anaconda_exe")
    Write-Output "Installing Anaconda"
    Start-Process -FilePath "$PSScriptRoot\$anaconda_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Anaconda installation file"
    Remove-Item -Path $PSScriptRoot\$anaconda_exe -Confirm:$false
}

function Install-Docker {
    $docker_exe = "Docker Desktop Installer.exe"
    Write-Output "Downloading Docker into path $PSScriptRoot\$docker_exe"
    $webClient.DownloadFile("https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe", "$PSScriptRoot\$docker_exe")
    Write-Output "Installing Docker"
    Start-Process -FilePath "$PSScriptRoot\$docker_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Docker installation file"
    Remove-Item -Path $PSScriptRoot\$docker_exe -Confirm:$false
}

function Install-Atom {
    $atom_exe = "AtomSetup-x64.exe"
    Write-Output "Downloading Atom into path $PSScriptRoot\$atom_exe"
    $webClient.DownloadFile("https://atom.io/download/windows_x64", "$PSScriptRoot\$atom_exe")
    Write-Output "Installing Atom"
    Start-Process -FilePath "$PSScriptRoot\$atom_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up Atom installation file"
    Remove-Item -Path $PSScriptRoot\$atom_exe -Confirm:$false
}

function Install-Cinema4D {
    $cinema4d_exe = "Cinema4D-21.115_Win_Autoinstaller.exe"
    Write-Output "Downloading Cinema4D into path $PSScriptRoot\$cinema4d_exe"
    $webClient.DownloadFile("https://installer.maxon.net/installer/21.115_RB297076/Cinema4D-21.115_Win_Autoinstaller.exe", "$PSScriptRoot\$cinema4d_exe")
    Write-Output "Installing Cinema4D"
    Start-Process -FilePath "$PSScriptRoot\$cinema4d_exe" -Wait

    Write-Output "Cleaning up Cinema4D installation file"
    Remove-Item -Path $PSScriptRoot\$cinema4d_exe -Confirm:$false
}

function Install-GeForceExperience {
    $geforce_exe = "GeForce_Experience_v3.20.2.34.exe"
    Write-Output "Downloading GeForce Experience into path $PSScriptRoot\$geforce_exe"
    $webClient.DownloadFile("https://us.download.nvidia.com/GFE/GFEClient/3.20.2.34/GeForce_Experience_v3.20.2.34.exe", "$PSScriptRoot\$geforce_exe")
    Write-Output "Installing GeForce Experience"
    Start-Process -FilePath "$PSScriptRoot\$geforce_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up GeForce Experience installation file"
    Remove-Item -Path $PSScriptRoot\$geforce_exe -Confirm:$false
}

function Install-Lightworks {
    Write-Output "Installing Lightworks through Chocolatey"
    choco install lightworks --force
}

function Install-VS2019 {
    Write-Output "Installing Visual Studio Professional 2019 through Chocolatey"
    choco install visualstudio2019professional --force
}

function Install-VSCode {
    Write-Output "Installing Visual Studio Code through Chocolatey"
    choco install vscode --force
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
    $7zip_exe = "7z1900-x64.exe"
    Write-Output "Downloading 7Zip into path $PSScriptRoot\$7zip_exe"
    $webClient.DownloadFile("https://www.7-zip.org/a/7z1900-x64.exe", "$PSScriptRoot\$7zip_exe")
    Write-Output "Installing 7Zip"
    Start-Process -FilePath "$PSScriptRoot\$7zip_exe" -ArgumentList "/qn" -Wait

    Write-Output "Cleaning up 7Zip installation file"
    Remove-Item -Path $PSScriptRoot\$7zip_exe -Confirm:$false
}

function Install-WSL {
    Write-Output "Installing Windows Subsystem for Linux through Chocolatey"
    choco install wsl --force
}

function Set-Time {
    Write-Output "Setting Time & Timezone to Automatic"
    Set-ItemProperty -path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name Type -Value NTP | Out-Null
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate -Name Start -Value 00000003 | Out-Null
}

function Disable-NetworkWindow {
    Write-Output "Disabling New Network Window"
    if((Test-RegistryValue -path HKLM:\SYSTEM\CurrentControlSet\Control\Network -Value NewNetworkWindowOff)-eq $true) {} Else {new-itemproperty -path HKLM:\SYSTEM\CurrentControlSet\Control\Network -name "NewNetworkWindowOff" | Out-Null}
}

function Set-MousePrecision {
    Write-Output "Enabling Enhanced Pointer Precision"
    Set-Itemproperty -Path 'HKCU:\Control Panel\Mouse' -Name MouseSpeed -Value 1 | Out-Null
}
    
function Enable-MouseKeys {
    Write-Output "Enabling Mouse Keys"
    set-Itemproperty -Path 'HKCU:\Control Panel\Accessibility\MouseKeys' -Name Flags -Value 63 | Out-Null
}

function Disable-Logout {
    Write-Output "Disabling Logout Option in Start Menu"
    if((Test-RegistryValue -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Value StartMenuLogOff )-eq $true) {Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name StartMenuLogOff -Value 1 | Out-Null} Else {New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name StartMenuLogOff -Value 1 | Out-Null}
}
    
function Disable-Lock {
    Write-Output "Disable Lock Option in Start Menu"
    if((Test-Path -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System) -eq $true) {} Else {New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies -Name Software | Out-Null}
    if((Test-RegistryValue -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Value DisableLockWorkstation) -eq $true) {Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name DisableLockWorkstation -Value 1 | Out-Null } Else {New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name DisableLockWorkstation -Value 1 | Out-Null}
}

function Disable-Shutdown {
    Write-Output "Disabling Shutdown Option in Start Menu"
    New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name NoClose -Value 1 | Out-Null
}
    
function Show-FileExtensions {
    Write-Output "Showing File Extensions"
    Set-itemproperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name HideFileExt -Value 0 | Out-Null
}
  
function Set-FractalDirectory {
    Write-Output "Creating Fractal Directory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal' -ItemType directory | Out-Null}
}

function Install-DotNetFramework {
    Write-Output "Installing .Net Framework Core 4.7 through Chocolatey"
    choco install dotnet4.7 --force
}

function Disable-HyperV {
    $url = "https://gallery.technet.microsoft.com/PowerShell-Device-60d73bb0/file/147248/2/DeviceManagement.zip"
    $compressed_file = "DeviceManagement.zip"
    $extract_folder = "DeviceManagement"

    Write-Output "Downloading Device Management Powershell Script from $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$compressed_file")
    Unblock-File -Path "$PSScriptRoot\$compressed_file"

    Write-Output "Extracting Device Management Powershell Script"
    Expand-Archive "$PSScriptRoot\$compressed_file" -DestinationPath "$PSScriptRoot\$extract_folder" -Force

    Write-Output "Disabling Hyper-V Video"
    Import-Module "$PSScriptRoot\$extract_folder\DeviceManagement.psd1"
    Get-Device | Where-Object -Property Name -Like "Microsoft Hyper-V Video" | Disable-Device -Confirm:$false

    Write-Output "Cleaning up Hyper-V Video disabling file"
    Remove-Item -Path $PSScriptRoot\$compressed_file -Confirm:$false
    Remove-Item -Path $PSScriptRoot\$extract_folder -Confirm:$false -Recurse
}

function Install-Fractal {
    $fractal_exe = "fractal.exe"
    $fractal_path = "C:\Program Files\Fractal"

    Write-Output "Downloading Fractal into path $fractal_path\$fractal_exe"
    $webClient.DownloadFile("TODO-S3Bucket", "$fractal_path\$fractal_exe")

    Write-Output "Installing Fractal"
    Start-Process -FilePath "$fractal_path\$fractal_exe" -ArgumentList "/qn" -Wait
}

function Install-NvidiaTeslaPublicDrivers {
    Write-Output "Installing Nvidia Public Driver (GRID already installed at deployment through Azure)"
    $driver_file = "441.22-tesla-desktop-win10-64bit-international.exe"
    $version = "441.22"
    $url = "http://us.download.nvidia.com/tesla/441.22/441.22-tesla-desktop-win10-64bit-international.exe"
    
    Write-Output "Downloading Nvidia M60 driver from URL $url"
    $webClient.DownloadFile($url, "$PSScriptRoot\$driver_file")

    Write-Output "Installing Nvidia M60 driver from file $PSScriptRoot\$driver_file"
    Start-Process -FilePath "$PSScriptRoot\$driver_file" -ArgumentList "-s", "-noreboot" -Wait
    Start-Process -FilePath "C:\NVIDIA\$version\setup.exe" -ArgumentList "-s", "-noreboot" -Wait
}

function Set-OptimalGPUSettings {
    Write-Output "Setting Optimal Tesla M60 GPU Settings"
    .\C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi --auto-boost-default=0
    .\C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi -ac "2505,1177"
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