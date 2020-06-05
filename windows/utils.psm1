# This file contains the functions called in the PowerShell scripts
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$webClient = New-Object System.Net.WebClient

function DownloadFile ($url, $path) {
    Write-Output "Downloading $url to $path"
    if ($env:QUIET -eq 'yes')  {
        Write-Output "Quietly.................."
        $global:ProgressPreference = 'SilentlyContinue'    # Subsequent calls do not display UI.
    }
    Invoke-WebRequest -URI $url -OutFile $path
    if ($env:QUIET -eq 'yes')  {
        $global:ProgressPreference = 'Continue'            # Subsequent calls do display UI.
    }
}

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
    } catch {
        return $false
    }
}

function Set-FilePermission ($file_path) {
    # helper function for setting permissiosn of a file
    $acl = Get-Acl $file_path
    $acl.SetAccessRuleProtection($true, $false)
    $administratorsRule = New-Object system.security.accesscontrol.filesystemaccessrule("Administrators", "FullControl", "Allow")
    $systemRule = New-Object system.security.accesscontrol.filesystemaccessrule("SYSTEM", "FullControl", "Allow")
    $acl.SetAccessRule($administratorsRule)
    $acl.SetAccessRule($systemRule)
    $acl | Set-Acl
}

function Invoke-RemotePowerShellCommand ([SecureString] $credentials, $command_as_a_string) {
    # this helper scripts authenticates to the Fractal user via Remote-PowerShell, and runs the specified command in userspace
    Write-Output "Get Public IPv4"
    $IPv4 = (Invoke-WebRequest -UseBasicParsing -uri "https://api.ipify.org/").Content

    Write-Output "Invoke Command in New Remote-PSSession"
    $SO = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
    $session = New-PSSession -ConnectionUri https://"$IPv4":5986 -Credential $credentials -SessionOption $SO
    Invoke-Command -Session $session -ScriptBlock { $command_as_a_string }

    Write-Output "Done, Removing PS-Session(s)"
    Remove-PSSession -Id 1, 2
}

function Update-Windows {
    if ($env:NO_UPDATE -eq 'yes')  {
        Write-Output "Skipping Windows Update"
        return
    }
    $url = "https://gallery.technet.microsoft.com/scriptcenter/Execute-Windows-Update-fc6acb16/file/144365/1/PS_WinUpdate.zip"
    $compressed_file = "PS_WinUpdate.zip"
    $update_script = "PS_WinUpdate.ps1"

    Write-Output "Downloading Windows Update Powershell Script from $url"
    DownloadFile $url "C:\$compressed_file"
    Unblock-File -Path "C:\$compressed_file"

    Write-Output "Extracting Windows Update Powershell Script"
    Expand-Archive "C:\$compressed_file" -DestinationPath "C:\" -Force

    Write-Output "Running Windows Update"
    Invoke-Expression "C:\$update_script"

    Write-Output "Cleaning up Windows Update installation files"
    Remove-Item -Path "C:\$update_script" -Confirm:$false
    Remove-Item -Path "C:\$compressed_file" -Confirm:$false
    Remove-Item -Path "C:\TestServ01_Report.txt" -Confirm:$false 
    Remove-Item -Path "C:\$($env:COMPUTERNAME)_Report.txt" -Confirm:$false -ErrorAction SilentlyContinue
}

function Update-Firewall {
    Write-Output "Enable ICMP Ping in Firewall"
    Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True
}

function Disable-TCC {
    Write-Output "Disable TCC Mode on Nvidia Tesla GPU"
    if ((Test-Path -Path "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe") -eq $true) {
        $nvsmi = "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
        $gpu = & $nvsmi --format=csv,noheader --query-gpu=pci.bus_id
        & $nvsmi -g $gpu -fdm 0
    } else {
        Write-Output "Skipping Disable-TCC, no nvidia-smi found"
    }
}

function Add-AutoLogin ($admin_username, [SecureString] $admin_password) {
    Write-Output "Make the password and account of admin user never expire"
    Set-LocalUser -Name $admin_username -PasswordNeverExpires $true -AccountNeverExpires

    Write-Output "Make the admin login at startup"
    if ($env:VAGRANT -eq 'yes')  {
        Write-Output "Vagrant detected. Skipping enable Autologin to Fractal account"
        return
    }

    $registry = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $registry "AutoAdminLogon" -Value "1" -Type String
    Set-ItemProperty $registry "DefaultDomainName" -Value "$env:COMPUTERNAME" -Type String 
    Set-ItemProperty $registry "DefaultUsername" -Value $admin_username -Type String
    Set-ItemProperty $registry "DefaultPassword" -Value $admin_password -Type String
}

function Disable-Cursor {
    # makes the Windows cursor blank to avoid duplicate cursor issue
    Write-Output "Downloading the Blank Cursor File"
    $cursorPath = "C:\Program Files\Fractal\Assets\blank.cur"
    $cursorPath_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/blank.cur"
    DownloadFile $cursorPath_url $cursorPath

    Write-Output "Opening the Windows Cursor Registry"
    $RegConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser","$env:COMPUTERNAME")
    $RegCursors = $RegConnect.OpenSubKey("Control Panel\Cursors",$true)
    
    Write-Output "Setting the Windows Cursors to Blank"
    $RegCursors.SetValue("", $cursorPath)
    $RegCursors.SetValue("AppStarting", $cursorPath)
    $RegCursors.SetValue("Arrow", $cursorPath)
    $RegCursors.SetValue("Crosshair", $cursorPath)
    $RegCursors.SetValue("Hand", $cursorPath)
    $RegCursors.SetValue("Help", $cursorPath)
    $RegCursors.SetValue("IBeam", $cursorPath)
    $RegCursors.SetValue("No", $cursorPath)
    $RegCursors.SetValue("NWPen", $cursorPath)
    $RegCursors.SetValue("SizeAll", $cursorPath)
    $RegCursors.SetValue("SizeNESW", $cursorPath)
    $RegCursors.SetValue("SizeNS", $cursorPath)
    $RegCursors.SetValue("SizeNWSE", $cursorPath)
    $RegCursors.SetValue("SizeWE", $cursorPath)
    $RegCursors.SetValue("UpArrow", $cursorPath)
    $RegCursors.SetValue("Wait", $cursorPath)
    
    Write-Output "Closing the Windows Cursor Registry"
    $RegCursors.Close()
    $RegConnect.Close()
    
# define C# signature for modifying system parameters
$CSharpSig = @'
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(
                    uint uiAction,
                    uint uiParam,
                    uint pvParam,
                    uint fWinIni);
'@
    
    Write-Output "Refresh the Cursor Parameter to Enable Changes"
    $CursorRefresh = Add-Type -MemberDefinition $CSharpSig -Name WinAPICall -Namespace SystemParamInfo -PassThru
    $CursorRefresh::SystemParametersInfo(0x0057, 0, $null, 0)
}

function Enable-RemotePowerShell ([SecureString] $certificate_password) {
    ###
    # the following steps are based on: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/winrm
    ###

    # the following commmented-out steps only need to be run once to set-up Azure for using WinRM VMs
    # they are left here for reference, but should not be run every time a new VM gets created

    # This following block of steps can also be done directly in the Azure Portal under Key Vaults, which is faster and simpler
    # Write-Output "Create Fractal Azure Key Vault -- These needs to be run in Azure Portal PowerShell Terminal"
    # Install-Module -Name Az -AllowClobber -Force
    # Connect-AzAccount # You will need to enter the username and password for the Fractal Azure account
    # New-AzKeyVault -VaultName "FractalKeyVault" -ResourceGroupName "Fractal" -Location "East US" -EnabledForDeployment -EnabledForTemplateDeployment
    # Set-AzKeyVaultAccessPolicy -VaultName "FractalKeyVault" -ResourceGroupName "Fractal" -EnabledForDeployment

    # Write-Output "Creating Self-signed Certificate"
    # $certificateName = "FractalCertificate"
    # $thumbprint = (New-SelfSignedCertificate -DnsName $certificateName -CertStoreLocation Cert:\CurrentUser\My -KeySpec KeyExchange).Thumbprint
    # $cert = (Get-ChildItem -Path cert:\CurrentUser\My\$thumbprint)
    # Export-PfxCertificate -Cert $cert -FilePath ".\$certificateName.pfx" -Password $certificate_password

    # Write-Output "Uploading Self-signed Certificate to Azure Key Vault"
    # $fileName = ".\$certificateName.pfx"
    # $fileContentBytes = Get-Content $fileName -Encoding Byte
    # $fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)
    
# # this needs to not-be indented, otherwise it will fail...   
# $jsonObject = @"
# {
#   "data": "$filecontentencoded",
#   "dataType" :"pfx",
#   "password": "$certificate_password"
# }
# "@

    # $jsonObjectBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonObject)
    # $jsonEncoded = [System.Convert]::ToBase64String($jsonObjectBytes)
    
    # $secret = ConvertTo-SecureString -String $jsonEncoded -AsPlainText –Force
    # Set-AzKeyVaultSecret -VaultName "FractalKeyVault" -Name "FractalWinRMSecret" -SecretValue $secret

    # Write-Output "Uploading the URL for Self-signed Certificate in the Key Vault"
    # $secretURL = (Get-AzKeyVaultSecret -VaultName "FractalKeyVault" -Name "FractalWinRMSecret").Id

    # the rest of this script configures a VM to allow remote powershell for userspace scripts
    Write-Output "Setting WinRM for PowerShell Remoting"
    if ($env:VAGRANT  -eq 'yes')  {
        Write-Output "Vagrant detected.  Skipping enable Remote Powershell"
        return
    }
    Start-Service WinRM
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
    New-ItemProperty -Name LocalAccountTokenFilterPolicy -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -PropertyType DWord -Value 1

    Write-Output "Opening WinRM Firewall"
    New-NetFirewallRule -Name "winrm_http" -DisplayName "winRM HTTP" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5985 -Protocol TCP
    New-NetFirewallRule -Name "winrm_https" -DisplayName "winRM HTTPS" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP

    Write-Output "Enabling PowerShell Remoting"
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
    Get-PSSessionConfiguration
}

function Install-FractalWallpaper ($run_on_cloud, $credentials) {
    # sleep for 15 seconds to make sure previous operations completed
    Start-Sleep -s 15

    # first download the wallpaper
    Write-Output "Downloading Fractal Wallpaper"
    $fractalwallpaper_name = "C:\Program Files\Fractal\Assets\wallpaper.png"
    $fractalwallpaper_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/wallpaper.png"
    DownloadFile $fractalwallpaper_url $fractalwallpaper_name

    Write-Output "Setting Fractal Wallpaper"
    # if this script was meant to run on the cloud, we run via Remote-PS (to run from a webserver)
    if ($run_on_cloud) {
        $command = 'if((Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
        if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value Wallpaper) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -PropertyType String -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null}
        if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value WallpaperStyle) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -value 2 | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -PropertyType String -value 2 | Out-Null}'
        Invoke-RemotePowerShellCommand $credentials $command  
    }
    # else we run the command directly
    else {
        if((Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
        if((Test-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Value Wallpaper) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -Value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null} else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -PropertyType String -Value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null}
        if((Test-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Value WallpaperStyle) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -Value 2 | Out-Null} else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -PropertyType String -Value 2 | Out-Null}
    }
}

function Install-FractalService {
    # first download the service executable
    Write-Output "Downloading Fractal Service"
    $fractalservice_name = "C:\Program Files\Fractal\FractalService.exe"
    $fractalservice_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/FractalService.exe"
    DownloadFile $fractalservice_url $fractalservice_name

    # then install the service
    Write-Output "Enabling Fractal Service"
    cmd.exe /c 'sc.exe Create "Fractal" binPath= "\"C:\Program Files\Fractal\FractalService.exe\"" start= "auto"' | Out-Null
    cmd.exe /c 'sc.exe description "Fractal" "Fractal Service"' | Out-Null
    sc.exe Start 'Fractal' | Out-Null
}

function Enable-FractalFirewallRule {
    Write-host "Creating Fractal Firewall Rule"
    New-NetFirewallRule -DisplayName "Fractal" -Direction Inbound -Program "C:\Program Files\Fractal\FractalServer.exe" -Profile Private, Public -Action Allow -Enabled True | Out-Null
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
    $hardware_id = "VBAudioVACWDM"

    Write-Output "Downloading Virtual Audio Driver"
    DownloadFile "http://vbaudio.jcedeveloppement.com/Download_CABLE/VBCABLE_Driver_Pack43.zip" "C:\$compressed_file"
    Unblock-File -Path "C:\$compressed_file"

    Write-Output "Extracting Virtual Audio Driver"
    Expand-Archive "C:\$compressed_file" -DestinationPath "C:\$driver_folder" -Force

    $wdk_installer = "wdksetup.exe"
    $devcon = "C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe"

    Write-Output "Downloading Windows Development Kit installer"
    DownloadFile "http://go.microsoft.com/fwlink/p/?LinkId=526733" "C:\$wdk_installer"

    # installing in user session via $credentials
    Write-Output "Downloading and installing Windows Development Kit"
    Start-Process -FilePath "C:\$wdk_installer" -ArgumentList "/S" -Wait

    $cert = "vb_cert.cer"
    $url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/vb_cert.cer"

    Write-Output "Downloading VB certificate from $url"
    DownloadFile $url "C:\$cert"

    Write-Output "Importing VB certificate"
    Import-Certificate -FilePath "C:\$cert" -CertStoreLocation "cert:\LocalMachine\TrustedPublisher"

    Write-Output "Installing Virtual Audio Driver"
    Start-Process -FilePath $devcon -ArgumentList "install", "C:\$driver_folder\$driver_inf", $hardware_id -Wait

    Write-Output "Cleaning up Virtual Audio Driver installation files"
    Remove-Item -Path "C:\$driver_folder" -Confirm:$false -Recurse
    Remove-Item -Path "C:\$wdk_installer" -Confirm:$false
    Remove-Item -Path "C:\$compressed_file" -Confirm:$false
    Remove-Item -Path "C:\$cert" -Confirm:$false

    Write-Output "Removing WDK Desktop shortcuts"
    Remove-Item -Path "C:\Users\Public\Desktop\Windows TShell.lnk" -Confirm:$false
    Remove-Item -Path "C:\Users\Public\Desktop\WPCups.lnk" -Confirm:$false
}

function Install-Chocolatey {
    Write-Output "Installing Chocolatey"
    if (Get-Command chocolatey -errorAction SilentlyContinue) {
        Write-Output "Chocolatey exists, skipping installation"
        chocolatey feature enable -n allowGlobalConfirmation
    } else {
        $ProgressPreference = 'SilentlyContinue'    # Subsequent calls do not display UI.
        Invoke-Expression ($webClient.DownloadString('https://chocolatey.org/install.ps1'))
        $ProgressPreference = 'Continue'            # Subsequent calls do display UI.
        chocolatey feature enable -n allowGlobalConfirmation
    }
}

function Choco-Install ($package) {
    if ($env:QUIET -eq 'yes')  {
        Write-Output "Quietly.................."
        choco install $package -y --no-progress
    } else {
        choco install $package -y
    }

}

function Install-Steam {
    Write-Output 'Installing Steam through Chrocolatey'
    Choco-Install steam
}

function Install-Discord {
    Write-Output "Installing Discord through Chocolatey"
    Choco-Install discord
}

function Install-GoogleChrome {
    Write-Output 'Installing Google Chrome through Chrocolatey'
    if ($env:QUIET -eq 'yes')  {
        Write-Output "Quietly.................."
        choco install googlechrome -y --ignore-checksums --no-progress
    } else {
        choco install googlechrome -y --ignore-checksums
    }
}

function Install-EpicGamesLauncher {
    Write-Output 'Installing Epic Games Launcher through Chrocolatey'
    Choco-Install epicgameslauncher 
}

function Install-Blizzard {
    $blizzard_exe = "Battle.net-Setup.exe"
    Write-Output "Downloading Blizzard Battle.Net Launcher into path C:\$blizzard_exe"
    DownloadFile 'https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP&id=634826696.1580926426' "C:\$blizzard_exe"

    Write-Output "Installing Blizzard Battle.Net Launcher"
    Start-Process -FilePath "C:\$blizzard_exe" -ArgumentList "/q" -Wait

    Write-Output "Cleaning up Blizzard Battle.Net Launcher installation file"
    Remove-Item -Path "C:\$blizzard_exe" -Confirm:$false
}

function Install-Git {
    Write-Output "Installing Git through Chocolatey"
    Choco-Install git
}

function Install-OpenCV {
    Write-Output "Installing OpenCV through Chocolatey"
    Choco-Install opencv
}

function Install-Firefox {
    Write-Output "Installing Mozilla Firefox through Chocolatey"
    Choco-Install firefox
}

function Install-VLC {
    Write-Output "Installing VLC through Chocolatey"
    Choco-Install vlc
}

function Install-Gimp {
    Write-Output "Installing Gimp through Chocolatey"
    Choco-Install gimp
}

function Install-Dropbox {
    Write-Output "Installing Dropbox through Chocolatey"
    Choco-Install dropbox
}

function Install-NodeJS {
    Write-Output "Installing NodeJS through Chocolatey"
    Choco-Install nodejs
}

function Install-AndroidStudio {
    Write-Output "Installing Android Studio through Chocolatey"
    Choco-Install androidstudio
}

function Install-Telegram {
    Write-Output "Installing Telegram through Chocolatey"
    Choco-Install telegram.install
}

function Install-Whatsapp {
    Write-Output "Installing Whatsapp through Chocolatey"
    Choco-Install whatsapp
}

function Install-GitHubDesktop {
    Write-Output "Installing GitHub Desktop through Chocolatey"
    Choco-Install github-desktop
}

function Install-Unity {
    Write-Output "Installing Unity through Chocolatey"
    Choco-Install unity
}

function Install-SublimeText {
    Write-Output "Installing Sublime Text 3 through Chocolatey"
    Choco-Install sublimetext3
}

function Install-Blender {
    Write-Output "Installing Blender through Chocolatey"
    Choco-Install blender
}

function Install-AdobeAcrobat {
    Write-Output "Installing Adobe Acrobat Reader DC through Chocolatey"
    Choco-Install adobereader
}

function Install-Skype {
    Write-Output "Installing Skype through Chocolatey"
    Choco-Install skype
}

function Install-AdobeCreativeCloud {
    Write-Output "Adobe Creative Cloud is not downloadable without an Adobe subscription and thus cannot be installed"
}

function Install-DaVinciResolve {
    Write-Output "DaVinci Resolve is not downloadable without a DaVinci Resolve subscription and thus cannot be installed"
}

function Install-ZBrush {
    Write-Output "ZBrush is not downloadable without a ZBrush subscription and thus cannot be installed"
}

function Install-AutodeskMaya {
    Write-Output "Autodesk Maya is not downloadable without an Autodesk subscription and thus cannot be installed"
}

function Install-3DSMaxDesign {
    Write-Output "Autodesk 3DS Max Design is not downloadable without an Autodesk subscription and thus cannot be installed"
}

function Install-Solidworks {
    Write-Output "Solidworks is not downloadable without a D'Assault Systemes subscription and thus cannot be installed"
}

function Install-Matlab {
    Write-Output "Matlab is not downloadable without a MathWorks subscription and thus cannot be installed"
}

function Install-Mathematica {
    Write-Output "Mathematica is not downloadable without an Wolfram subscription and thus cannot be installed"
}

function Install-Zoom {
    Write-Output "Installing Zoom through Chocolatey"
    Choco-Install zoom
}

function Install-Office {
    Write-Output "Installing Microsoft Office Suite through Chocolatey"
    Choco-Install microsoft-office-deployment
}

function Install-CUDAToolkit {
    Write-Output "Installing CUDA Development Toolkit through Chocolatey"
    Choco-Install cuda
}

function Install-LLVM {
    Write-Output "Installing LLVM & Clang through Chocolatey"
    Choco-Install llvm
}

function Install-Anaconda {
    Write-Output "Installing Anaconda (Python 3) through Chocolatey"
    Choco-Install anaconda3
}

function Install-Docker {
    Write-Output "Installing Docker through Chocolatey"
    Choco-Install docker
}

function Install-Curl {
    Write-Output "Installing Curl through Chocolatey"
    Choco-Install curl
}

function Install-Atom {
    Write-Output "Installing Atom through Chocolatey"
    Choco-Install atom
}

function Install-Cinema4D {
    Write-Output "Installing Cinema4D through Chocolatey"
    Choco-Install cinebench
}

function Install-GeForceExperience {
    Write-Output "Installing Nvidia GeForce Experience through Chocolatey"
    Choco-Install geforce-experience
}

function Install-Lightworks {
    Write-Output "Installing Lightworks through Chocolatey"
    Choco-Install lightworks
}

function Install-VSPro2019 {
    Write-Output "Installing Visual Studio Professional 2019 through Chocolatey"
    Choco-Install visualstudio2019professional
}

function Install-Cmake {
    Write-Output "Installing Cmake through Chocolatey"
    Choco-Install cmake
}

function Install-Cppcheck {
    Write-Output "Installing Cppcheck through Chocolatey"
    Choco-Install cppcheck
}

function Install-VisualRedist {
    Write-Output "Installing Visual C++ Redistribuable 2017 through Chocolatey"
    Choco-Install vcredist2017
}

function Install-VSCode {
    Write-Output "Installing Visual Studio Code through Chocolatey"
    Choco-Install vscode
}

function Install-Fusion360 {
    Write-Output "Installing Autodesk Fusion360 through Chocolatey"
    Choco-Install autodesk-fusion360
}

function Install-Spotify {
    Write-Output "Installing Spotify through Chocolatey"
    Choco-Install spotify
}

function Install-GOG {
    Write-Output "Installing GOG through Chocolatey"
    Choco-Install goggalaxy
}

function Install-7Zip {
    Write-Output "Installing 7-Zip through Chocolatey"
    Choco-Install 7zip
}

function Install-WSL {
    Write-Output "Installing Windows Subsystem for Linux through Chocolatey"
    Choco-Install wsl
}

function Set-Time {
    Write-Output "Setting Time & Timezone to Automatic"
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name Type -Value NTP | Out-Null
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name Start -Value 00000003 | Out-Null
}

function Disable-NetworkWindow {
    Write-Output "Disabling New Network Window"
    if((Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network" -Value NewNetworkWindowOff) -eq $true) {} else {New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network" -Name "NewNetworkWindowOff" | Out-Null}
}

function Set-MousePrecision ($run_on_cloud, $credentials) {
    Write-Output "Enabling Enhanced Pointer Precision"
    # if this script was meant to run on the cloud, we run via Remote-PS (to run from a webserver)    
    if ($run_on_cloud) {
        Invoke-RemotePowerShellCommand $credentials 'Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 1 | Out-Null'
    } else {
        # else we run the command directly
        Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 1 | Out-Null
    }
}
    
function Enable-MouseKeys ($run_on_cloud, $credentials) {
    Write-Output "Enabling Mouse Keys"
    # if this script was meant to run on the cloud, we run via Remote-PS (to run from a webserver)    
    if ($run_on_cloud) {
        Invoke-RemotePowerShellCommand $credentials 'Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\MouseKeys" -Name Flags -Value 63 | Out-Null'
    } else {
        # else we run the command directly
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\MouseKeys" -Name Flags -Value 63 | Out-Null
    }
}

function Disable-Logout {
    Write-Output "Disabling Logout Option in Start Menu"
    if((Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Value StartMenuLogOff ) -eq $true) {Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name StartMenuLogOff -Value 1 | Out-Null} else {New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name StartMenuLogOff -Value 1 | Out-Null}
}
    
function Disable-Lock {
    Write-Output "Disable Lock Option in Start Menu"
    if((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} else {New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies" -Name Software | Out-Null}
    if((Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value DisableLockWorkstation) -eq $true) {Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableLockWorkstation -Value 1 | Out-Null } else {New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableLockWorkstation -Value 1 | Out-Null}
}

function Disable-Shutdown {
    Write-Output "Disabling Shutdown Option in Start Menu"
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoClose -Value 1 | Out-Null
}

function Install-PoshSSH {
    Write-Output "Install Posh-SSH via PowerShell"
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force # NuGet needed first
    Install-Module -Name Posh-SSH -Confirm:$False -Force
}

function Show-FileExtensions ($run_on_cloud, $credentials) {
    Write-Output "Setting File Extensions"
    # if this script was meant to run on the cloud, we run via Remote-PS (to run from a webserver)    
    if ($run_on_cloud) {
        Invoke-RemotePowerShellCommand $credentials 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 | Out-Null'
    } else {
        # else we run the command directly
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 | Out-Null
    }
}
  
function Set-FractalDirectory {
    Write-Output "Creating Fractal Directory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal') -eq $true) {} else {New-Item -Path 'C:\Program Files\Fractal' -ItemType directory | Out-Null}

    Write-Output "Creating Fractal Asset Subdirectory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal\Assets') -eq $true) {} else {New-Item -Path 'C:\Program Files\Fractal\Assets' -ItemType directory | Out-Null}

    Write-Output "Creating Fractal Exit Subdirectory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal\Exit') -eq $true) {} else {New-Item -Path 'C:\Program Files\Fractal\Exit' -ItemType directory | Out-Null}
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
    DownloadFile $url "C:\$compressed_file"
    Unblock-File -Path "C:\$compressed_file"

    Write-Output "Extracting Device Management Powershell Script"
    Expand-Archive "C:\$compressed_file" -DestinationPath "C:\$extract_folder" -Force

    Write-Output "Disabling Hyper-V Video"
    Import-Module "C:\$extract_folder\DeviceManagement.psd1"
    Get-Device | Where-Object -Property Name -Like "Microsoft Hyper-V Video" | Disable-Device -Confirm:$false

    Write-Output "Cleaning HyperV Disabling"
    Remove-Item -Path "C:\$compressed_file" -Confirm:$false
}

function Install-FractalServer ($protocol_branch) {
    # only download, server will get started by service -- download the master branch for users
    Write-Output "Downloading Fractal Server"
    $fractalserver_name = "C:\Program Files\Fractal\FractalServer.exe"
    $fractalserver_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/$protocol_branch/FractalServer.exe"
    DownloadFile $fractalserver_url $fractalserver_name

    Write-Output "Download Shared FFmpeg Libs from S3"
    $shared_libs_name = "C:\shared-libs.tar.gz"
    $shared_libs_url = "https://fractal-protocol-shared-libs.s3.amazonaws.com/shared-libs.tar.gz"
    DownloadFile $shared_libs_url $shared_libs_name

    Write-Output "Unzip the .tar.gz File and Remove shared-libs.tar.gz & /lib"
    Get-Command tar
    # diverts stderr to null to avoid remote powershell issue
    # https://stackoverflow.com/questions/2095088/error-when-calling-3rd-party-executable-from-powershell-when-using-an-ide/20950421
    & cmd /c 'tar -xvzf .\shared-libs.tar.gz 2>&1'
    Remove-Item -Path $shared_libs_name -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\lib" -Confirm:$false -Recurse -ErrorAction SilentlyContinue

    $arch = (Get-WmiObject Win32_Processor).AddressWidth

    Write-Output "Move the FFmpeg .dlls to the Fractal Folder and Remove /share"
    Move-Item -Path "C:\share\$arch\Windows\avcodec-58.dll" -Destination "C:\Program Files\Fractal\avcodec-58.dll"
    Move-Item -Path "C:\share\$arch\Windows\avdevice-58.dll" -Destination "C:\Program Files\Fractal\avdevice-58.dll"
    Move-Item -Path "C:\share\$arch\Windows\avfilter-7.dll" -Destination "C:\Program Files\Fractal\avfilter-7.dll"
    Move-Item -Path "C:\share\$arch\Windows\avformat-58.dll" -Destination "C:\Program Files\Fractal\avformat-58.dll"
    Move-Item -Path "C:\share\$arch\Windows\avresample-4.dll" -Destination "C:\Program Files\Fractal\avresample-4.dll"
    Move-Item -Path "C:\share\$arch\Windows\avutil-56.dll" -Destination "C:\Program Files\Fractal\avutil-56.dll"
    Move-Item -Path "C:\share\$arch\Windows\postproc-55.dll" -Destination "C:\Program Files\Fractal\postproc-55.dll"
    Move-Item -Path "C:\share\$arch\Windows\swscale-5.dll" -Destination "C:\Program Files\Fractal\swscale-5.dll"
    Move-Item -Path "C:\share\$arch\Windows\swresample-3.dll" -Destination "C:\Program Files\Fractal\swresample-3.dll"
    Remove-Item -Path "C:\share" -Confirm:$false -Recurse -ErrorAction SilentlyContinue
}

function Install-FractalAutoUpdate ($protocol_branch) {
    # no need to download version, update.bat will download it
    Write-Output "Downloading Fractal Auto Update script"
    $fractal_update_name = "C:\Program Files\Fractal\update.bat"
    $fractal_update_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/$protocol_branch/update.bat"
    DownloadFile $fractal_update_url $fractal_update_name
}

function Install-FractalExitScript {
    # only download, gets called by the vbs file
    Write-Output "Downloading Fractal Exit script"
    $fractal_exitbat_name = "C:\Program Files\Fractal\Exit\ExitFractal.bat"
    $fractal_exitbat_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/ExitFractal.bat"
    DownloadFile $fractal_exitbat_url $fractal_exitbat_name
    
    # download vbs file for running .bat file without terminal
    Write-Output "Downloading Fractal Exit VBS helper script"
    $fractal_exitvbs_name = "C:\Program Files\Fractal\Exit\Exit.vbs"
    $fractal_exitvbs_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/Exit.vbs"
    DownloadFile $fractal_exitvbs_url $fractal_exitvbs_name

    # download the Fractal logo for the icons
    Write-Output "Downloading Fractal Logo icon"
    $fractal_icon_name = "C:\Program Files\Fractal\Assets\logo.ico"
    $fractal_icon_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/logo.ico"
    DownloadFile $fractal_icon_url $fractal_icon_name

    # create desktop shortcut 
    Write-Output "Creating Exit Fractal Desktop Shortcut"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:Public\Desktop\Exit Fractal.lnk")
    $Shortcut.TargetPath = "C:\Program Files\Fractal\Exit\Exit.vbs"
    $Shortcut.IconLocation="C:\Program Files\Fractal\Assets\logo.ico"
    $Shortcut.Save()

    # create start menu shortcut
    Write-Output "Creating Exit Fractal Start Menu Shortcut"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_Exit Fractal_.lnk")
    $Shortcut.TargetPath = "C:\Program Files\Fractal\Exit\Exit.vbs"
    $Shortcut.IconLocation = "C:\Program Files\Fractal\Assets\logo.ico"
    $Shortcut.Save()
}

function Install-NvidiaTeslaPublicDrivers {
    Write-Output "Installing Nvidia Public Driver (GRID already installed at deployment through Azure)"
    $driver_file = "442.50-tesla-desktop-win10-64bit-international.exe"
    $url = "http://us.download.nvidia.com/tesla/442.50/442.50-tesla-desktop-win10-64bit-international.exe" # this URL needs to be updated periodically when a new driver version comes out
    
    Write-Output "Downloading Nvidia M60 driver from $url"
    DownloadFile $url "C:\$driver_file"

    Write-Output "Installing Nvidia M60 driver from $driver_file"
    Start-Process -FilePath "C:\$driver_file" -ArgumentList "-s", "-noreboot" -Wait

    Write-Output "Cleaning up Nvidia Public Drivers installation file"
    Remove-Item -Path "C:\$driver_file" -Confirm:$false
}

function Set-OptimalGPUSettings {
    if ((Test-Path -Path "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe") -eq $true) {
        Write-Output "Setting Optimal Tesla M60 GPU Settings"
        C:\'Program Files'\'NVIDIA Corporation'\NVSMI\.\nvidia-smi --auto-boost-default=0
        C:\'Program Files'\'NVIDIA Corporation'\NVSMI\.\nvidia-smi -ac "2505,1177"
    } else {
        Write-Output "Skipping Set-OptimalGPUSettings, no nvidia-smi found"
    }
}

function Install-DirectX {
    $directx_exe = "directx_Jun2010_redist.exe"
    Write-Output "Downloading DirectX into path C:\$direct_exe"
    DownloadFile "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" "C:\$directx_exe"
    
    Write-Output "Creating temporary DirectX directory in C:\"
    if((Test-Path -Path '\DirectX') -eq $true) {} else {New-Item -Path '\DirectX' -ItemType directory | Out-Null}

    Write-Output "Installing DirectX"
    Start-Process -FilePath "C:\$directx_exe" "/T:C:\DirectX /Q" -Wait

    Write-Output "Cleaning up DirectX installation file"
    Remove-Item -Path "C:\$directx_exe" -Confirm:$false
}

function Install-Unison {
    Write-Output "Downloading Unison File Sync from S3 Bucket" 
    $unison_name = "C:\Program Files\Fractal\unison.exe"
    $unison_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/unison.exe"
    DownloadFile $unison_url $unison_name
}

function Enable-SSHServer {
    Write-Output "Adding OpenSSH Server Capability"
    if ($env:LOCAL -eq 'yes')  {
        Write-Output "Local detected.  Skipping OpenSSH reconfiguration"
        return
    }
    if ($env:VAGRANT -eq 'yes')  {
        Write-Output "Vagrant detected.  Skipping OpenSSH reconfiguration"
        return
    }

    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction SilentlyContinue
    if (-not $?) {
        Write-Output "Add-WindowsCapability Failed, Trying DISM"
        dism /online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
        # both failed, need to contact support
        if (-not $?) {
            Write-Output "OpenSSH Server Failed to Install -- Contact support@fractalcomputers.com for Help"
        }
    }

    # NOTE: these commented out lines are for later, when we update the webserver to exchange SSH keys
    # Write-Output "Generating SSH Key"     
    # ssh-keygen -f sshkey -q -N """"
    # $From = Get-Content -Path sshkey.pub
    # Add-Content -Path C:\ProgramData\ssh\administrators_authorized_keys -Value $From
    # Get-Content -Path C:\ProgramData\ssh\administrators_authorized_keys    

    Write-Output "Downloading new OpenSSH Server Config and SSH Keys"     
    DownloadFile "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/sshd_config" "C:\ProgramData\ssh\sshd_config"
    DownloadFile "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/ssh_host_ecdsa_key.pub" "C:\ProgramData\ssh\ssh_host_ecdsa_key.pub"
    DownloadFile "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/ssh_host_ecdsa_key" "C:\ProgramData\ssh_host_ecdsa_key"
    DownloadFile "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/administrator_authorized_keys" "C:\ProgramData\ssh\administrator_authorized_keys"

    Write-Output "Enable Permissions on OpenSSH Config and SSH Keys Files"
    Set-FilePermission "C:\ProgramData\ssh\sshd_config"
    Set-FilePermission "C:\ProgramData\ssh\ssh_host_ecdsa_key.pub"
    Set-FilePermission "C:\ProgramData\ssh_host_ecdsa_key"
    Set-FilePermission "C:\ProgramData\ssh\administrator_authorized_keys"

    Write-Output "Starting the SSH Server"
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'
    Get-NetFirewallRule -Name *ssh* # didn't seem needed, but just in case
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 # didn't seem needed, but just in case

    Write-Output "Adding Unison Executable Path"
    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\Program Files\Fractal", [EnvironmentVariableTarget]::Machine)

    # Config ssh to force public key and disable password log in. This change also makes openssh look for the key in $user\.ssh/authorized_keys
    $FilePath = "C:\ProgramData\ssh\sshd_config"
    (Get-Content ($FilePath)) | Foreach-Object {$_ -replace '^Match Group administrators', (" ")} | Set-Content  ($Filepath)
    (Get-Content ($FilePath)) | Foreach-Object {$_ -replace '^       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', (" ")} | Set-Content  ($Filepath)
    (Get-Content ($FilePath)) | Foreach-Object {$_ -replace '^PasswordAuthentication yes', ("PasswordAuthentication no")} | Set-Content  ($Filepath)
    Add-Content $FilePath "`nAuthenticationMethods publickey"
}
