# This file contains the functions called in the PowerShell scripts
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$webClient = New-Object System.Net.WebClient

#### Helper functions ####
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

function Launch-RemotePowerShellCommand ($command_as_a_string) {







   






    

    Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
    Set-NetFirewallRule -Name "WINRM-HTTPS-In-TCP-PUBLIC" -RemoteAddress Any




    Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any

    Set-Service WinRM -ComputerName $servers -startuptype Automatic



    Set-PSSessionConfiguration Microsoft.PowerShell -ShowSecurityDescriptorUI




    #
    $IPv4 = (Invoke-WebRequest -UseBasicParsing -uri "https://api.ipify.org/").Content
    $hostname = hostname
    $Password = "password1234567."
    $User = "Fractal"
    $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)

    $so = New-PsSessionOption –SkipCACheck -SkipCNCheck
    $session = New-PSSession -ConnectionURI http://"$IPv4":5985 -Credential $Credentials -SessionOption $so
    Invoke-Command -Session $session -ScriptBlock { Get-ChildItem C:\ }





    Invoke-Command -ConnectionURI https://"$IPv4":5985 -ScriptBlock { Get-ChildItem C:\ } -Credential $psCred -SessionOption $so



    $so = New-PsSessionOption –SkipCACheck -SkipCNCheck
    $session = New-PSSession ConnectionURI https://"$IPv4":5985 -Credential $psCred -SessionOption $so
    Invoke-Command -Session $session -ScriptBlock { Get-ChildItem C:\ }





    Enter-PSSession -ConnectionUri https://<public-ip-dns-of-the-vm>:port -Credential $cred -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck) -Authentication Negotiate



    ######
    $IPv4 = (Invoke-WebRequest -UseBasicParsing -uri "https://api.ipify.org/").Content
    $hostname = hostname
    $UserName = "Fractal"
    $Password = ConvertTo-SecureString "password1234567." -AsPlainText -Force



    $psCred = New-Object System.Management.Automation.PSCredential($UserName, $Password)
#    Invoke-Command -ComputerName $IPv4 -ScriptBlock { Get-ChildItem C:\ } -Credential $psCred

    Enter-PSSession -ComputerName $IPv4 -Credential "Fractal" -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck)


    Enter-PSSession -ConnectionUri "$IPv4:5986" -Credential "$hostname/Fractal" -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck)





    #
    $IPv4 = (Invoke-WebRequest -UseBasicParsing -uri "https://api.ipify.org/").Content
    $Password = "password1234567."
    $User = "Fractal"
    $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)



    Test-WsMan $IPv4
    Invoke-Command -ComputerName $IPv4 -ScriptBlock { Get-ChildItem C:\ } -Credential $Credentials




    Enable-WSManCredSSP $IPv4 –DelegateComputer $IPv4
    Enable-WSManCredSSP $IPv4
    Enter-PSSession $IPv4 -Authentication CredSSP -Credential Fractal


    # TODO

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
    New-NetFirewallRule -DisplayName "WinRM HTTPS" -Direction Inbound -LocalPort 5986 -Profile Private, Public -Protocol TCP -Action Allow -Enabled True | Out-Null
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
    Get-PSSessionConfiguration
    $so = New-PsSessionOption –SkipCACheck -SkipCNCheck
    $session = New-PSSession -ComputerName "52.168.66.248" -Credential "Fractal" -ConfigurationName Microsoft.PowerShell -UseSSL -SessionOption $so
    Invoke-Command -Session $session -ScriptBlock { $PSVersionTable }


    Enable-PSRemoting -SkipNetworkProfileCheck -Force

    New-PSSession -ConnectionURI https://Fractal.fractalcomputers.com/52.170.41.191




    Enter-PSSession –ComputerName 52.170.41.191 -Credential Get-Credential

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value 52.170.41.191

    # credentials
    $admin_username = "Fractal"
    $admin_password = (ConvertTo-SecureString "password1234567." -AsPlainText -Force)
    $credentials = New-Object System.Management.Automation.PSCredential $admin_username, $admin_password
    $so = New-PsSessionOption –SkipCACheck -SkipCNCheck
    $IPv4 = (Invoke-WebRequest -UseBasicParsing -uri "https://api.ipify.org/").Content
    Write-Output $IPv4
    Enter-PSSession -ComputerName $IPv4 -Credential $credentials -UseSSL -SessionOption $so
     






    
    Enter-PSSession -ConnectionUri https://<public-ip-dns-of-the-vm>:5986 -Credential $cred -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck) -Authentication Negotiate




    Invoke-Command -ComputerName $IPv4 -Credential $credentials -UseSSL -SessionOption $so -ScriptBlock { $PSVersionTable }



    Enter-PSSession -ComputerName "52.168.66.248"  -Credential "Fractal" -UseSSL -SessionOption $so
 

        
    $session = New-PSSession -ComputerName "52.168.66.248"  -Credential "Fractal" -ConfigurationName Microsoft.PowerShell -UseSSL
    Invoke-Command -Session $session -ScriptBlock { $PSVersionTable }


 
    # credentials
    $admin_username = "Fractal"
    $admin_password = (ConvertTo-SecureString "password1234567." -AsPlainText -Force)
    $credentials = New-Object System.Management.Automation.PSCredential $admin_username, $admin_password


    # 
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
    Get-PSSessionConfiguration
    
    $session = New-PSSession -ComputerName 52.168.66.248 -Credential $credentials -ConfigurationName Microsoft.PowerShell -UseSSL


    Invoke-Command -Session $session -ScriptBlock { $PSVersionTable }



    # then set the wallpaper
    Write-Output "Setting Fractal Wallpaper"
    $file = "C:\cloud-1.ps1"
    Start-Process Powershell.exe -Credential $credentials -ArgumentList ("-file $file")






}
########

function Update-Windows {
    $url = "https://gallery.technet.microsoft.com/scriptcenter/Execute-Windows-Update-fc6acb16/file/144365/1/PS_WinUpdate.zip"
    $compressed_file = "PS_WinUpdate.zip"
    $update_script = "PS_WinUpdate.ps1"

    Write-Output "Downloading Windows Update Powershell Script from $url"
    $webClient.DownloadFile($url, "C:\$compressed_file")
    Unblock-File -Path "C:\$compressed_file"

    Write-Output "Extracting Windows Update Powershell Script"
    Expand-Archive "C:\$compressed_file" -DestinationPath "C:\" -Force

    Write-Output "Running Windows Update"
    Invoke-Expression "C:\$update_script"

    Write-Output "Cleaning up Windows Update installation files"
    Remove-Item -Path "C:\$update_script" -Confirm:$false
    Remove-Item -Path "C:\$compressed_file" -Confirm:$false
    Remove-Item -Path "C:\TestServ01_Report.txt" -Confirm:$false
    Remove-Item -Path "C:\$($env:COMPUTERNAME)_Report.txt" -Confirm:$false
}

function Update-Firewall {
    Write-Output "Enable ICMP Ping in Firewall"
    Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True
}

function Disable-TCC {
    Write-Output "Disable TCC Mode on Nvidia Tesla GPU"
    $nvsmi = "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
    $gpu = & $nvsmi --format=csv,noheader --query-gpu=pci.bus_id
    & $nvsmi -g $gpu -fdm 0
}

function Add-AutoLogin ($admin_username, [SecureString] $admin_password) {
    Write-Output "Make the password and account of admin user never expire"
    Set-LocalUser -Name $admin_username -PasswordNeverExpires $true -AccountNeverExpires

    Write-Output "Make the admin login at startup"
    $registry = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $registry "AutoAdminLogon" -Value "1" -Type String
    Set-ItemProperty $registry "DefaultDomainName" -Value "$env:COMPUTERNAME" -Type String 
    Set-ItemProperty $registry "DefaultUsername" -Value $admin_username -Type String
    Set-ItemProperty $registry "DefaultPassword" -Value $admin_password -Type String
}




function Set-RemotePowerShell {
    # this function configures a VM to allow remote powershell for user-space scripts
    Write-Output "Getting the Public IPv4 Address of VM"
    $IPv4 = (Invoke-WebRequest -UseBasicParsing -uri "https://api.ipify.org/").Content

    Write-Output "Setting WinRM for PowerShell Remoting"
    Start-Service WinRM
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $IPv4 -Force
    New-ItemProperty -Name LocalAccountTokenFilterPolicy -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -PropertyType DWord -Value 1

    Write-Output "Enabling PowerShell Remoting"
    Enable-PSRemoting -SkipNetworkProfileCheck -Force



    # this firewall thing works
    New-NetFirewallRule -Name "winrm_http" -DisplayName "winrm_http" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5985 -Protocol TCP
    New-NetFirewallRule -Name "winrm_https" -DisplayName "winrm_https" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP








    # Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force

    New-SelfSignedCertificate -DnsName Fractal.fractalcomputers.com -CertStoreLocation Cert:\LocalMachine\My

    winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="Fractal.fractalcomputers.com";CertificateThumbprint="F0A37B6C3CB1FA6724B7FDE5F43408DBF0392126"}

}




function Install-FractalWallpaper ($run_on_local, $credentials) {
    # first download the wallpaper
    Write-Output "Downloading Fractal Wallpaper"
    $fractalwallpaper_name = "C:\Program Files\Fractal\Assets\wallpaper.png"
    $fractalwallpaper_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/wallpaper.png"
    $webClient.DownloadFile($fractalwallpaper_url, $fractalwallpaper_name)

    Write-Output "Setting Fractal Wallpaper"
    # if this script was meant to run locally (via RDP), we run the command directly
    if ($run_on_local) {
        if((Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
        if((Test-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Value Wallpaper) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -Value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -PropertyType String -Value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null}
        if((Test-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Value WallpaperStyle) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -Value 2 | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -PropertyType String -Value 2 | Out-Null}
    }
    # else we run via Remote-PS (to run from a webserver)
    else {
        $command = 'if((Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
        if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value Wallpaper) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -PropertyType String -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null}
        if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value WallpaperStyle) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -value 2 | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -PropertyType String -value 2 | Out-Null}'
        Launch-RemotePowerShellCommand $command        
    }
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
    $webClient.DownloadFile("http://vbaudio.jcedeveloppement.com/Download_CABLE/VBCABLE_Driver_Pack43.zip", "C:\$compressed_file")
    Unblock-File -Path "C:\$compressed_file"

    Write-Output "Extracting Virtual Audio Driver"
    Expand-Archive "C:\$compressed_file" -DestinationPath "C:\$driver_folder" -Force

    $wdk_installer = "wdksetup.exe"
    $devcon = "C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe"

    Write-Output "Downloading Windows Development Kit installer"
    $webClient.DownloadFile("http://go.microsoft.com/fwlink/p/?LinkId=526733", "C:\$wdk_installer")

    # installing in user session via $credentials
    Write-Output "Downloading and installing Windows Development Kit"
    Start-Process -FilePath "C:\$wdk_installer" -ArgumentList "/S" -Wait

    $cert = "vb_cert.cer"
    $url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/vb_cert.cer"

    Write-Output "Downloading VB certificate from $url"
    $webClient.DownloadFile($url, "C:\$cert")

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
    Invoke-Expression ($webClient.DownloadString('https://chocolatey.org/install.ps1'))
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
    Write-Output "Downloading Blizzard Battle.Net Launcher into path C:\$blizzard_exe"
    $webClient.DownloadFile("https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP&id=634826696.1580926426", "C:\$blizzard_exe")    
    Write-Output "Installing Blizzard Battle.Net Launcher"
    Start-Process -FilePath "C:\$blizzard_exe" -ArgumentList "/q" -Wait

    Write-Output "Cleaning up Blizzard Battle.Net Launcher installation file"
    Remove-Item -Path "C:\$blizzard_exe" -Confirm:$false
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
    Write-Output "Adobe Creative Cloud is not downloadable without an Adobe subscription and thus cannot be installed"
}

function Install-DaVinciResolve {
    Write-Output "DaVinci Resolve is not downloadable without an Adobe subscription and thus cannot be installed"
}

function Install-ZBrush {
    Write-Output "ZBrush is not downloadable without an Adobe subscription and thus cannot be installed"
}

function Install-AutodeskMaya {
    Write-Output "Autodesk Maya is not downloadable without an Adobe subscription and thus cannot be installed"
}

function Install-3DSMaxDesign {
    Write-Output "Autodesk 3DS Max Design is not downloadable without an Adobe subscription and thus cannot be installed"
}

function Install-Solidworks {
    Write-Output "Solidworks is not downloadable without an Adobe subscription and thus cannot be installed"
}

function Install-Matlab {
    Write-Output "Matlab is not downloadable without an Adobe subscription and thus cannot be installed"
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

function Install-WSL {
    Write-Output "Installing Windows Subsystem for Linux through Chocolatey"
    choco install wsl --force
}

function Set-Time {
    Write-Output "Setting Time & Timezone to Automatic"
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name Type -Value NTP | Out-Null
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name Start -Value 00000003 | Out-Null
}

function Disable-NetworkWindow {
    Write-Output "Disabling New Network Window"
    if((Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network" -Value NewNetworkWindowOff) -eq $true) {} Else {New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network" -Name "NewNetworkWindowOff" | Out-Null}
}

function Set-MousePrecision ($run_on_local, $credentials) {
    Write-Output "Enabling Enhanced Pointer Precision"
    # if this script was meant to run locally (via RDP), we run the command directly
    if ($run_on_local) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 1 | Out-Null
    }
    # else we run via Remote-PS (to run from a webserver)
    else {
        Launch-RemotePowerShellCommand 'Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 1 | Out-Null'
    }
}
    
function Enable-MouseKeys ($run_on_local, $credentials) {
    Write-Output "Enabling Mouse Keys"
    # if this script was meant to run locally (via RDP), we run the command directly
    if ($run_on_local) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\MouseKeys" -Name Flags -Value 63 | Out-Null
    }
    # else we run via Remote-PS (to run from a webserver)
    else {
        Launch-RemotePowerShellCommand 'Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\MouseKeys" -Name Flags -Value 63 | Out-Null'
    }
}

function Disable-Logout {
    Write-Output "Disabling Logout Option in Start Menu"
    if((Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Value StartMenuLogOff ) -eq $true) {Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name StartMenuLogOff -Value 1 | Out-Null} Else {New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name StartMenuLogOff -Value 1 | Out-Null}
}
    
function Disable-Lock {
    Write-Output "Disable Lock Option in Start Menu"
    if((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} Else {New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies" -Name Software | Out-Null}
    if((Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value DisableLockWorkstation) -eq $true) {Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableLockWorkstation -Value 1 | Out-Null } Else {New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name DisableLockWorkstation -Value 1 | Out-Null}
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

function Show-FileExtensions ($run_on_local, $credentials) {
    Write-Output "Setting File Extensions"
    # if this script was meant to run locally (via RDP), we run the command directly
    if ($run_on_local) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 | Out-Null
    }
    # else we run via Remote-PS (to run from a webserver)
    else {
        Launch-RemotePowerShellCommand 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 | Out-Null'
    }
}
  
function Set-FractalDirectory {
    Write-Output "Creating Fractal Directory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal' -ItemType directory | Out-Null}

    Write-Output "Creating Fractal Asset Subdirectory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal\Assets') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal\Assets' -ItemType directory | Out-Null}

    Write-Output "Creating Fractal Exit Subdirectory in C:\Program Files\"
    if((Test-Path -Path 'C:\Program Files\Fractal\Exit') -eq $true) {} Else {New-Item -Path 'C:\Program Files\Fractal\Exit' -ItemType directory | Out-Null}
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
    $webClient.DownloadFile($url, "C:\$compressed_file")
    Unblock-File -Path "C:\$compressed_file"

    Write-Output "Extracting Device Management Powershell Script"
    Expand-Archive "C:\$compressed_file" -DestinationPath "C:\$extract_folder" -Force

    Write-Output "Disabling Hyper-V Video"
    Import-Module "C:\$extract_folder\DeviceManagement.psd1"
    Get-Device | Where-Object -Property Name -Like "Microsoft Hyper-V Video" | Disable-Device -Confirm:$false

    Write-Output "Cleaning HyperV Disabling"
    Remove-Item -Path "C:\$compressed_file" -Confirm:$false
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
    $driver_file = "441.22-tesla-desktop-win10-64bit-international.exe"
    $url = "http://us.download.nvidia.com/tesla/442.50/442.50-tesla-desktop-win10-64bit-international.exe" # this URL needs to be updated periodically when a new driver version comes out
    
    Write-Output "Downloading Nvidia M60 driver from $url"
    $webClient.DownloadFile($url, "C:\$driver_file")

    Write-Output "Installing Nvidia M60 driver from $driver_file"
    Start-Process -FilePath "C:\$driver_file" -ArgumentList "-s", "-noreboot" -Wait

    Write-Output "Cleaning up Nvidia Public Drivers installation file"
    Remove-Item -Path "C:\$driver_file" -Confirm:$false
}

function Set-OptimalGPUSettings {
    Write-Output "Setting Optimal Tesla M60 GPU Settings"
    C:\'Program Files'\'NVIDIA Corporation'\NVSMI\.\nvidia-smi --auto-boost-default=0
    C:\'Program Files'\'NVIDIA Corporation'\NVSMI\.\nvidia-smi -ac "2505,1177"
}

function Install-DirectX {
    $directx_exe = "directx_Jun2010_redist.exe"
    Write-Output "Downloading DirectX into path C:\$direct_exe"
    $webClient.DownloadFile("https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe", "C:\$directx_exe")
    
    Write-Output "Creating temporary DirectX directory in C:\"
    if((Test-Path -Path '\DirectX') -eq $true) {} Else {New-Item -Path '\DirectX' -ItemType directory | Out-Null}

    Write-Output "Installing DirectX"
    Start-Process -FilePath "C:\$directx_exe" "/T:C:\DirectX /Q" -Wait

    Write-Output "Cleaning up DirectX installation file"
    Remove-Item -Path "C:\$directx_exe" -Confirm:$false
}

function Install-Unison {
    Write-Output "Downloading Unison File Sync from S3 Bucket" 
    $unison_name = "C:\Program Files\Fractal\unison.exe"
    $unison_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/unison.exe"
    $webClient.DownloadFile($unison_url, $unison_name)
}

function Enable-SSHServer {
    Write-Output "Adding OpenSSH Server Capability"
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
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
    $webClient.DownloadFile("https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/sshd_config", "C:\ProgramData\ssh\sshd_config")
    $webClient.DownloadFile("https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/ssh_host_ecdsa_key.pub", "C:\ProgramData\ssh\ssh_host_ecdsa_key.pub")
    $webClient.DownloadFile("https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/ssh_host_ecdsa_key", "C:\ProgramData\ssh_host_ecdsa_key")
    $webClient.DownloadFile("https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/administrator_authorized_keys", "C:\ProgramData\ssh\administrator_authorized_keys")

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
