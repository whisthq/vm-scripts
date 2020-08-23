# Fractal Setup Scripts

![Install CI](https://github.com/fractalcomputers/setup-scripts/workflows/Install%20CI/badge.svg)

This repository contains the Fractal PowerShell and Bash scripts that get launched at creation of a cloud computer/container to set it up in a specific configuration, or when a user sets up their personal computer for peer-to-peer streaming. The base scripts are run on every virtual machine or container, and custom application installation scripts can be run at creation of a Fractal cloud computer (not applicable to containers, who are user-agnostic and only support a specific application) to install requested applications. A combination of many scripts can be run.

## Cloud Setup Scripts

The general cloud scripts, `cloud.ps1` for Windows, and `cloud-0.sh` & `cloud-1.sh` for Linux Ubuntu, always gets installed and sets up the cloud computer for optimal general usage with Fractal. The scripts will update the OS, download all the relevant drivers and Fractal libraries and executables, and install the basic software required for rapid onboarding on a new cloud computer. You can find the relevant scripts in `/windows` and `/linux`; they call a utils script, respectively `utils.psm1`, which is also stored in AWS S3 (since the `cloud.ps1` script is run directly in the cloud VM/container via RDP) and `utils.sh`, which is only stored locally in this GitHub repository (since the `cloud-X.sh` scripts are run locally via SSH into the cloud VM/container). Calling the cloud scripts requires the password of the VM or container as an argument. 

### Preparing a Base Virtual Machine Disk

For our production virtual machines and containers, we create a base disk/image, which we simply clone/deploy every time a new user signs up, which saves us having to run these scripts every single time. However, we need to periodically prepare/improve those base disks/images. 

#### Windows base disks:

Here are the existing base Windows disks/containers:
- Azure East US
- Azure South Central US
- Azure North Central US

To create a Windows base disk, connect to the VM with the base disk attached over Microsoft RDP. You can then open a PowerShell terminal in Administrator mode, and copy/paste the content of `cloud.ps1` into the shell and wait for it to run. Once you are done, you should clean the bloatware on the VM, like Candy Crush and other useless software, and make sure that all residual installation files are properly deleted. Base disks should be as barebone as possible. 

#### Linux base disks:

There are currently no existing base Linux Ubuntu disks/containers deployed to production. 

To create a Linux base disk, run the `./setup-linux.sh` script in `/linux` subfolder -- it will call the respective `utils.sh` script hosted in this GitHub repository directly. Make sure to remove all unnecessary applications and detritus on the OS. It is recommended you then connect to the Linux base disk VM via Fractal and use the GUI to clean it up.

### Application Install Scripts

In addition to the OS-specific scripts, which install the minimum required to make Fractal work optimally on cloud computers, there also are functions to install specific applications. These functions are listed in `utils.psm1` and `utils.sh`, and are stored in a PostgresSQL database table which contains per-application commands, which are called when users select the application(s) they want to install on our website. Some of the softwares listed here cannot actually be installed through PowerShell/Bash, but are listed for potential manual install:

- Gaming Script
  - Nvidia GeForce (Windows only)
  - Steam 
  - Discord
  - Epic Games Launcher (Windows only)
  - GOG (Windows only)
  - Activision Blizzard (Windows only)

- Creative Script
  - Blender
  - Autodesk Maya
  - ZBrush (can't be installed without a subscription)
  - Adobe Creative Cloud (can't be installed without a subscription)
  - Cinema4D
  - 3DS Max Design (can't be installed without a subscription)
  - DaVinci Resolve (can't be installed without a subscription)
  - Lightworks
  - Unity

- Engineering Script
  - Solidworks (can't be installed without a subscription)
  - Autodesk Fusion 360 (Windows only)
  - Matlab (can't be installed without a subscription)
  - Mathematica (can't be installed without a subscription)

- Software Development Script
  - Windows Developer Mode Activated (Windows only)
  - Visual Studio Professional 2019 (Windows Only)
  - Visual Studio Code
  - Git
  - Windows Subsystem for Linux (Windows only)
  - Atom
  - Docker
  - CUDA Toolkit
  - Cmake
  - Cppcheck
  - LLVM & Clang-format
  - Android Studio
  - GitHub Desktop (Windows only)
  - Sublime Text
  - NodeJS
  - Python 2
  - Python 3
  - Postman
  - MinGW (Windows only)
  - GDB (Linux only)
  - Valgrind (Linux only)

- Data Science Script
  - Git
  - Anaconda & R Studio
  - OpenCV
  - Curl
  - Gimp

- Productivity Script
  - Slack
  - Microsoft Office Suite (Windows Only)
  - Adobe Acrobat Reader DC
  - Skype
  - Zoom
  - Telegram
  - Whatsapp
  - Firefox
  - VLC
  - Dropbox

## Peer-to-Peer Setup Scripts

The general peer-to-peer scripts, `peer2peer.ps1` and `peer2peer.sh`, always gets installed and set up on a user's local computer for streaming with Fractal. The scripts will mostly only install Fractal and set necessary drivers and firewall rules. You can find more information about exactly what commands they run in the windows and linux subfolders READMEs.

## Publishing the Scripts

The cloud, Windows DPI and peer-to-peer scripts are only hosted in this repository. The helpers scripts, like `utils.psm1`, are hosted in AWS S3 at https://s3.console.aws.amazon.com/s3/home?region=us-east-1 so that they can be downloaded and called from the base scripts.

To automatically upload new scripts to AWS S3 for production, run `./update.sh`. This script will upload the new scripts to AWS S3 and notify the team in Slack. Note that it will upload both Windows and Linux scripts, and will also upload the helper files, like configuration files, auto-update scripts, and so on.

If you get permission denied, or if this is your first time doing this for Fractal, you need to download the AWS CLI for your local platform. Your first need to install the CLI via your local package manager, i.e. `brew install awscli`, and then configure it via `aws configure`. This will prompt you for an AWS Acces Key ID and Secret Key ID. The parameters you need to set are:

- AWS Key: `AKIA24A776SSJU5PIIGY`
- Secret Key: `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`
- Region: `us-east-1`
- Format: `None`

The scripts will then uploaded to AWS S3 and be called next time you run a cloud of peer-to-peer script, which download the utils functions from S3. 
