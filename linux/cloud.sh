# This file contains the functions called in the Bash scripts

function UpdateLinux () {
    echo "Updating Linux Ubuntu"
    sudo apt-get update
    sudo apt-get upgade
}

function Install-Unison () {
    echo "Download Unison File Sync from S3 Bucket"
    wget -O /usr/share/fractal/unison "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/unison.exe"
}







function Install-Atom () {
    echo "Installing Atom through Snap"
    sudo snap install atom --classic
}

function Install-VSCode () {
    echo "Installing VSCode through Snap"
    sudo snap install vscode --classic
}

function Install-Docker () {
    echo "Installing Docker through Snap"
    sudo snap install docker --classic
}





