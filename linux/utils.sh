# This file contains the functions called in the Bash scripts

function UpdateLinux {
    echo "Updating Linux Ubuntu"
    yes | printf "password1234567." | sudo apt-get install wget
    yes | sudo apt-get update
    yes | sudo apt-get upgrade
}

function Set-Time {
    echo "Setting Automatic Time & Timezone via Gnome Clocks"
    yes | sudo apt-get install gnome-clocks
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












function Enable-FractalFirewallRule {
    Write-host "Creating Fractal Firewall Rule"
    New-NetFirewallRule -DisplayName "Fractal" -Direction Inbound -Program "C:\Program Files\Fractal\FractalServer.exe" -Profile Private, Public -Action Allow -Enabled True -Force | Out-Null
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



















function Install-AutodeskMaya {



    echo "Installing Autodesk Maya"
    echo "Installing Dependencies"


    sudo apt-get install alien dpkg-dev debhelper build-essential
    sudo apt-get ./libxp6_1.0.2-2_amd64.deb



    echo 'deb http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse' | sudo tee /etc/apt/sources.list.d/xenial.list    sudo apt-get update
    sudo apt-get install -y libtbb-dev libtiff5-dev libssl-dev libpng12-dev libssl1.0.0 gcc libjpeg62 libcurl4
    sudo apt-get install -y alien elfutils
    sudo apt-get install -y libaudiofile-dev libgstreamer-plugins-base0.10-0
    sudo apt-get install -y libglw1-mesa libglw1-mesa-dev mesa-utils
    sudo apt-get install -y xfonts-100dpi xfonts-75dpi ttf-mscorefonts-installer fonts-liberation
    sudo apt-get install -y csh tcsh libfam0 libfam-dev xfstt
    cd /tmp


    wget "http://launchpadlibrarian.net/183708483/libxp6_1.0.2-2_amd64.deb"
    sudo dpkg --force-all -i libxp6_1.0.2-2_amd64.deb
    sudo rm -f libxp6_1.0.2-2_amd64.deb

    echo "Download Maya and Converting to .deb"

    cd ~/Downloads
    wget "http://edutrial.autodesk.com/NET17SWDLD/2017/MAYA/ESD/Autodesk_Maya_2017_EN_JP_ZH_Linux_64bit.tgz"
    mkdir mayadir
    tar xvzf Autodesk_Maya_2017_EN_JP_ZH_Linux_64bit.tgz -C mayadir
    cd mayadir
    sudo alien -cv *.rpm
    sudo dpkg -i *.deb

    echo "int main (void) {return 0;}" > mayainstall.c
    gcc mayainstall.c
    sudo cp -v a.out /usr/bin/rpm


    sudo ln -s /usr/lib/x86_64-linux-gnu/libtbb.so /usr/lib/x86_64-linux-gnu/libtbb_preview.so.2
    sudo ln -s /usr/lib/x86_64-linux-gnu/libtiff.so /usr/lib/libtiff.so.3
    sudo ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/autodesk/maya2017/lib/libssl.so.10
    sudo ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so /usr/autodesk/maya2017/lib/libcrypto.so.10


    chmod +x setup
    sudo ./setup

}








function Install-FractalAutoUpdate {
    # no need to download version, update.sh will download it
    echo "Downloading Fractal Auto Update Script"
    sudo wget -O /usr/share/fractal/update.sh "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/update.sh"
}

function Install-NvidiaTeslaPublicDrivers {
    echo "Installing Nvidia Public Driver (GRID already installed at deployment through Azure)"
    echo "Downloading Nvidia M60 Driver from Nvidia Website"
    sudo wget http://us.download.nvidia.com/tesla/440.64.00/nvidia-driver-local-repo-ubuntu1804-440.64.00_1.0-1_amd64.deb
    
    echo "Installing Nvidia M60 Driver"
    sudo apt-key add /var/nvidia-driver-local-repo-440.64.00/7fa2af80.pub
    sudo dpkg -i nvidia-driver-local-repo-ubuntu1804-440.64.00_1.0-1_amd64.deb

    echo "Ceaning up Nvidia Public Drivers Installation"
    sudo rm -f nvidia-driver-local-repo-ubuntu1804-440.64.00_1.0-1_amd64.deb
}

function Set-OptimalGPUSettings {
    echo "Setting Optimal Tesla M60 GPU Settings"
    nvidia-smi --auto-boost-default=0
    nvidia-smi -ac "2505,1177"
}

function Disable-TCC {
    echo "Disable TCC Mode on Nvidia Tesla GPU"
    nvidia-smi -g -fdm 0 --format=csv,noheader --query-gpu=pci.bus_id
}

function Install-ProcessManager {
    # first download and install Immortal
    echo "Install Immortal Process Manager"
    curl -s https://packagecloud.io/install/repositories/immortal/immortal/script.deb.sh | sudo bash
    yes | sudo apt-get install immortal

    # then start Fractal with Immortal for auto-restart
    echo "Start FractalServer with Immortal"
    immortal /usr/share/fractal/./FractalServer
}

function Install-FractalServer {
    # only download, server will get started by process manager
    echo "Downloading Fractal Server"
    sudo wget -O /usr/share/fractal/FractalServer "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/FractalServer"

    # download the libraries
    echo "Downloading FFmpeg Libraries"
    sudo apt-get install libavcodec-dev libavdevice-dev libx11-dev libxtst-dev libxdamage-dev libasound2-dev xclip -y
}

function Install-7Zip {
    echo "Installing 7Zip through Apt"
    yes | sudo apt-get install p7zip-full
}

function Set-FractalDirectory {
    echo "Creating Fractal Directory in /usr/share"
    sudo [ -d /usr/share/fractal ] || sudo mkdir /usr/share/fractal

    echo "Creating Fractal Asset Subdirectory in /usr/share/fractal"
    sudo [ -d /usr/share/fractal/assets ] || sudo mkdir /usr/share/fractal/assets

    echo "Creating Fractal Exit Subdirectory in /usr/share/fractal"
    sudo [ -d /usr/share/fractal/exit ] || sudo mkdir /usr/share/fractal/exit

    echo "Creating Fractal Sync Subdirectory in /usr/share/fractal"
    sudo [ -d /usr/share/fractal/sync ] || sudo mkdir /usr/share/fractal/sync
}

function Install-Unison {
    echo "Downloading Unison File Sync from S3 Bucket"
    sudo wget -O /usr/share/fractal/unison "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/unison"
}

function Install-FractalWallpaper {
    # first download the wallpaper
    echo "Downloading Fractal Wallpaper"
    sudo wget -O /usr/share/fractal/assets/wallpaper.png "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/wallpaper.png"

    # then set the wallpaper
    echo "Setting Fractal Paper"
    gsettings set org.gnome.desktop.background picture-uri /usr/share/fractal/assets/wallpaper.png
}

function Install-AdobeAcrobat {
    echo "Installing Adobe Acrobat Reader"
    yes | sudo apt-get install gdebi-core libxml2:i386 libcanberra-gtk-module:i386 gtk2-engines-murrine:i386 libatk-adaptor:i386
    sudo wget "ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb"
    sudo gdebi "AdbeRdr9.5.5-1_i386linux_enu.deb"
    sudo rm -f "AdbeRdr9.5.5-1_i386linux_enu.deb"
}

function Install-VSCode {
    echo "Installing VSCode through Snap"
    sudo snap install vscode --classic
}

function Install-Docker {
    echo "Installing Docker through Snap"
    sudo snap install docker --classic
}

function Install-Blender {
    echo "Installing Blender through Snap"
    sudo snap install blender --classic
}

function Install-Git {
    echo "Installing Git through Apt"
    yes | sudo apt-get install git
}

function Install-Atom {
    echo "Installing Atom through Snap"
    sudo snap install atom --classic
}

function Install-Slack {
    echo "Installing Slack through Snap"
    sudo snap install slack --classic
}

function Install-OpenCV {
    echo "Installing OpenCV through Apt"
    yes | sudo apt-get install python3-opencv
}

function Install-GoogleChrome {
    echo "Installing Google Chrome"
    sudo wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    yes | sudo apt-get install ./google-chrome-stable_current_amd64.deb
    sudo rm -f "google-chrome-stable_current_amd64.deb"
}

function Install-Curl {
    echo "Installing Curl through Apt"
    yes | sudo apt-get install curl
}

function Install-Make {
    echo "Installing Make through Apt"
    yes | sudo apt-get install make
}

function Install-GCC {
    echo "Installing GCC through Apt"
    yes | sudo apt-get install gcc
}

function Install-Zoom {
    echo "Installing Zoom"
    sudo wget "https://zoom.us/client/latest/zoom_amd64.deb"
    yes | sudo apt-get install "./zoom_amd64.deb"
    sudo rm -f "./zoom_amd64.deb"
}

function Install-Skype {
    echo "Installing Skype through Snap"
    sudo snap install skype --classic
}

function Install-Anaconda {
    echo "Installing Anaconda"
    cd /tmp
    sudo wget "https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh"
    sudo sha256sum Anaconda3-2019.03-Linux-x86_64.sh
    sudo bash Anaconda3-2019.03-Linux-x86_64.sh -b    
    source ~/.bashrc
    export PATH=~/anaconda3/bin:$PATH

    echo "Cleaning up Anaconda Install"
    sudo rm -f "Anaconda3-2019.03-Linux-x86_64.sh"
    cd ~
}

function Install-Spotify {
    echo "Installing Spotify through Snap"
    sudo snap install spotify --classic
}

function Install-Discord {
    echo "Installing Discord through Snap"
    sudo snap install discord --classic
}

function Install-Steam {
    echo "Installing Steam through Apt"
    yes | sudo add-apt-repository multiverse
    yes | sudo apt-get update
    yes | sudo apt-get install steam
}

function Install-Matlab {
    echo "Matlab requires a license to be downloaded and thus cannot be installed"
}

function Install-Cinema4D {
    echo "Cinema4D does not run on Linux Ubuntu and thus cannot be installed"
}

function Install-Lightworks {
    sudo wget "https://downloads.lwks.com/v14-5/lightworks-14.5.0-amd64.deb"
    sudo dpkg -i "lightworks-14.5.0-amd64.deb"
    yes | sudo apt-get -f install
    sudo dpkg -i "lightworks-14.5.0-amd64.deb"
    sudo rm -f "lightworks-14.5.0-amd64.deb"
}

function Install-VSPro2019 {
    echo "Visual Studio Professional does not run on Linux Ubuntu and thus cannot be installed"
}

function Install-ZBrush {
    echo "ZBrush does not run on Linux Ubuntu and thus cannot be installed"
}

function Install-GOG {
    echo "GOG does not run on Linux Ubuntu and thus cannot be installed"
}

function Install-Blizzard {
    echo "Blizzard Battle.net does not run on Linux Ubuntu and thus cannot be installed"
}

function Install-EpicGamesLauncher {
    echo "Epic Games Launcher does not run on Linux and thus cannot be installed"
}

function Install-GeForceExperience {
    echo "GeForce Experience does not run on Linux and thus cannot be installed"
}

function Install-Solidworks {
    echo "Solidworks does not run on Linux and thus cannot be installed"
}

function Install-AdobeCreativeCloud {
    echo "Adobe Creative Cloud does not run on Linux and thus cannot be installed"
}

function Install-Office {
    echo "Microsoft Office does not run on Linux and thus cannot be installed"
}

function Install-Fusion360 {
    echo "Autodesk Fusion360 does not run on Linux Ubuntu and thus cannot be installed"
}

function Install-3DSMaxDesign {
    echo "Autodesk 3DSMaxDesign does not run on Linux Ubuntu and thus cannot be installed"
}

function Install-DaVinciResolve {
    echo "DaVinci Resolve does not run on Linux Ubuntu and thus cannot be installed"
}
