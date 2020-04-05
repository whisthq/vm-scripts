# This file contains the functions called in the Bash scripts

function UpdateLinux {
    echo "Updating Linux Ubuntu"
    sudo apt-get update
    sudo apt-get upgade
}

function Install-Unison {
    echo "Download Unison File Sync from S3 Bucket"
    sudo wget -O /usr/share/fractal/unison "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/unison"
}

function Install-Atom {
    echo "Installing Atom through Snap"
    sudo snap install atom --classic
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
    sudo apt-get install git
}


function Install-AutodeskMaya {



    echo 'deb http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse' | sudo tee /etc/apt/sources.list.d/xenial.list
    sudo apt-get update
    sudo apt-get install -y libtbb-dev libtiff5-dev libssl-dev libpng12-dev libssl1.0.0 gcc libjpeg62 libcurl4
    sudo apt-get install -y alien elfutils
    sudo apt-get install -y libaudiofile-dev libgstreamer-plugins-base0.10-0
    sudo apt-get install -y libglw1-mesa libglw1-mesa-dev mesa-utils
    sudo apt-get install -y xfonts-100dpi xfonts-75dpi ttf-mscorefonts-installer fonts-liberation
    sudo apt-get install -y csh tcsh libfam0 libfam-dev xfstt
    cd /tmp
    wget http://launchpadlibrarian.net/183708483/libxp6_1.0.2-2_amd64.deb
    sudo dpkg -i libxp6_1.0.2-2_amd64.deb
    cd ~/Downloads
    wget http://edutrial.autodesk.com/NET17SWDLD/2017/MAYA/ESD/Autodesk_Maya_2017_EN_JP_ZH_Linux_64bit.tgz
    mkdir mayadir




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
    sudo add-apt-repository multiverse
    sudo apt-get update
    sudo apt-get install steam
}

function Install-Curl {
    echo "Installing Curl through Apt"
    sudo apt-get install curl
}

function Install-Anaconda {
    echo "Installing Anaconda"
    cd /tmp
    sudo wget "https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh"
    sudo sha256sum Anaconda3-2019.03-Linux-x86_64.sh




    printf '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nn\n\n\n' | sudo Anaconda3-2019.03-Linux-x86_64.sh




    echo ""
    echo yes






    sudo rm Anaconda3-2019.03-Linux-x86_64.sh
    cd ~

}

function Install-OpenCV {
    echo "Installing OpenCV through Apt"
    sudo apt-get install python3-opencv
}


function Install-GoogleChrome {
    echo "Installing Google Chrome"
    sudo wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo apt-get install ./google-chrome-stable_current_amd64.deb
    sudo rm google-chrome-stable_current_amd64.deb
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







