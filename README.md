# Fractal Setup Scripts

![Install Tests](https://github.com/fractalcomputers/setup-scripts/workflows/Install%20Tests/badge.svg)

This repository contains the Fractal PowerShell and Bash scripts that get launched at creation of a cloud computer/container to set it up in a specific configuration, or when a user sets up their personal computer for peer-to-peer streaming. The cloud scripts can be toggled from a selection on the Fractal website in the cloud computer creation page, and are then fed to the Azure SDK when the VM gets created. A combination of many scripts can be run.

## Cloud Setup Scripts

The general cloud scripts, `cloud.ps1` for Windows, and `cloud-0.sh` & `cloud-1.sh` for Linux Ubuntu, always gets installed and sets up the cloud computer for optimal general usage with Fractal. The scripts will update the OS, download all the relevant drivers and Fractal libraries and executables, and install the basic software required for rapid onboarding on a new cloud computer.

In addition to the OS-specific scripts, which install the minimum required to make Fractal work optimally on cloud computers, there are usage-specific scripts. These scripts can be run from the cloud scripts by specifying boolean toggles as parameters. Some of the softwares listed here cannot actually be installed through PowerShell/Bash, but are listed for potential manual install:

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

The general peer-to-peer scripts, `peer2peer.ps1` and `peer2peer.sh`, always gets installed and set up a user's local computer for streaming with Fractal. The scripts will mostly only install Fractal and set necessary drivers and firewall rules. 

## Publishing the Scripts

The cloud, Windows DPI and peer-to-peer scripts are only hosted in this repository. The helpers scripts, like `utils.psm1`, are hosted in AWS S3 at https://s3.console.aws.amazon.com/s3/home?region=us-east-1 since they get called from the base scripts.

To automatically upload new scripts for production, run `./update.sh`. This script will upload the new scripts to AWS S3 and notify the team in Slack.

If you get permission denied, or if this is your first time doing this for Fractal, you need to download the AWS CLI for your local platform. Your first need to install the CLI via your local package manager, i.e. `brew install awscli`, and then configure it via `aws configure`. This will prompt you for an AWS Acces Key ID and Secret Key ID. You can find those [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/users/UpdateServer?section=security_credentials). You will need to create a new AWS Key and Secret Key for yourself. You should set `us-east-1` for the default region, and `None` for the format. The scripts will be updated in the S3 bucket, and the standard Fractal disk image, which gets cloned when new VMs are created, will need to be updated manually for each region.
