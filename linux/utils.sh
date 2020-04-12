# This file contains the functions called in the Bash scripts

function UpdateLinux {
    echo "Updating Linux Ubuntu"
    yes | printf "password1234567." | sudo apt-get install wget python python3
    yes | sudo apt-get update
    yes | sudo apt-get upgrade
}

function Set-Time {
    echo "Setting Automatic Time & Timezone via Gnome Clocks"
    yes | sudo apt-get install gnome-clocks
}

function Add-AutoLogin {
    echo "Automatic Login on Linux should be done manually via GUI"
}

function Enable-FractalFirewallRule {
    echo "Creating Fractal Firewall Rule"
    sudo ufw enable
    sudo ufw allow 22 # SSH
    sudo ufw allow 80 # HTTP
    sudo ufw allow 443 # HTTPS
    sudo ufw allow 32262 # Fractal Port Client->Server
    sudo ufw allow 32263 # Fractal Port Server->Client 
    sudo ufw allow 32264 # Fractal Port Shared-TCP
}

function Install-CustomGDMConfiguration {
   echo "Installing Custom Gnome Display Manager Configuration"
   sudo wget -O /etc/gdm3/custom.conf "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/custom.conf"
}

function Install-CustomX11Configuration {
   echo "Installing Custom X11 Configuration"
   sudo wget -O /usr/share/X11/xorg.conf.d/01-dummy.conf "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/usr/share/X11/xorg.conf.d/01-dummy.conf"
}

function Install-FractalLinuxInputDriver {
    # first download the driver symlink file
    echo "Install Fractal Linux Input Driver"
    sudo wget -O /usr/share/fractal/fractal-input.rules "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/fractal-input.rules"

    # symlink file
    # do this as root AFTER fractal-input.rules has been moved to the final install directory
    sudo groupadd fractal
    sudo usermod -a -G fractal Fractal # (the -a is VERY important, else you overwrite a user's groups)
    sudo ln -sf $(readlink -f fractal-input.rules) /etc/udev/rules.d/90-fractal-input.rules
}

function Disable-Shutdown {
    # based on: https://askubuntu.com/questions/453479/how-to-disable-shutdown-reboot-from-lightdm-in-14-04
    echo "Disabling Shutdown Option in Start Menu"
    sudo wget -O /etc/polkit-1/localauthority/50-local.d/restrict-login-powermgmt.pkla "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/restrict-login-powermgmt.pkla"
}
    
function Install-AutodeskMaya {
    echo "Installing Autodesk Maya"
    # Create Download Directory
    mkdir -p maya2017Install
    cd maya2017Install

    # Download Maya Install Files
    wget http://edutrial.autodesk.com/NET17SWDLD/2017/MAYA/ESD/Autodesk_Maya_2017_EN_JP_ZH_Linux_64bit.tgz
    sudo tar xvf Autodesk_Maya_2017_EN_JP_ZH_Linux_64bit.tgz

    # Install Dependencies
    yes | sudo apt-get install -y libssl1.0.0 gcc  libssl-dev libjpeg62 alien csh tcsh libaudiofile-dev libglw1-mesa elfutils libglw1-mesa-dev mesa-utils xfstt xfonts-100dpi xfonts-75dpi ttf-mscorefonts-installer libfam0 libfam-dev libcurl4-openssl-dev libtbb-dev
    yes | sudo apt-get install -y libtbb-dev 
    sudo wget http://launchpadlibrarian.net/183708483/libxp6_1.0.2-2_amd64.deb
    sudo wget http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb

    # Install Maya 
    sudo alien -cv *.rpm
    sudo dpkg -i *.deb
    echo "int main (void) {return 0;}" > mayainstall.c
    sudo gcc mayainstall.c
    sudo mv /usr/bin/rpm /usr/bin/rpm_backup
    sudo cp a.out /usr/bin/rpm
    sudo chmod +x ./setup
    sudo ./setup --noui
    sudo mv /usr/bin/rpm_backup /usr/bin/rpm
    sudo rm /usr/bin/rpm

    # Copy lib*.so
    sudo cp libQt* /usr/autodesk/maya2017/lib/
    sudo cp libadlm* /usr/lib/x86_64-linux-gnu/

    # Fix Startup Errors
    sudo ln -s /usr/lib/x86_64-linux-gnu/libtiff.so.5.3.0 /usr/lib/libtiff.so.3
    sudo ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/autodesk/maya2017/lib/libssl.so.10
    sudo ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so /usr/autodesk/maya2017/lib/libcrypto.so.10
    sudo ln -s /usr/lib/x86_64-linux-gnu/libtbb.so.2 /usr/lib/x86_64-linux-gnu/libtbb_preview.so.2
    sudo mkdir -p /usr/tmp
    sudo chmod 777 /usr/tmp
    sudo mkdir -p ~/maya/2017/
    sudo chmod 777 ~/maya/2017/

    # Fix Segmentation Fault Error
    echo "MAYA_DISABLE_CIP=1" >> ~/maya/2017/Maya.env

    # Fix Color Managment Errors
    echo "LC_ALL=C" >> ~/maya/2017/Maya.env
    sudo chmod 777 ~/maya/2017/Maya.env

    # Maya Camera Modifier Key
    sudo gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Super>"

    # Ensure that Fonts are Loaded
    sudo xset +fp /usr/share/fonts/X11/100dpi/
    sudo xset +fp /usr/share/fonts/X11/75dpi/
    sudo xset fp rehash

    # Cleanup
    echo "Maya was installed successfully"
    cd ..
    sudo rm -f -r maya2017Install
    cd ~
}

function Install-FractalExitScript {
    # download exit Bash script
    echo "Downloading Fractal Exit script"
    sudo wget -O /usr/share/fractal/exit.sh "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/exit.sh"

    # download the Fractal logo for the icons
    echo "Downloading Fractal Logo icon"
    sudo wget -O /usr/share/fractal/assets/logo.png "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/logo.png"

    # download the desktop shortcut and make it executable
    echo "Downloading Exit Fractal Desktop Shortcut"
    sudo wget -O "~/Desktop/Exit Fractal.desktop" "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/Exit Fractal.desktop"
    chmod a+x "Exit Fractal.desktop" # make shortcut executable

    # create favorites bar shortcut
    echo "Creating Exit Fractal Favorites Bar Shortcut"
    FAVORITES = "$(sudo dconf read /org/gnome/shell/favorite-apps)"
    sudo dconf write /org/gnome/shell/favorite-apps "${FAVORITES%?}, 'Exit Fractal.desktop']"
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
    immortal /usr/share/fractal/./FractalServer Fractal
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
