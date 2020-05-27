# Fractal Setup Scripts

This repository contains the Fractal PowerShell and Bash scripts that get launched at creation of a cloud computer/container to set it up in a specific configuration, or when a user sets up their personal computer for peer-to-peer streaming. The cloud scripts can be toggled from a selection on the Fractal website in the cloud computer creation page, and are then fed to the Azure SDK when the VM gets created. A combination of many scripts can be run.

## Cloud Setup Scripts

The general cloud scripts, `cloud.ps1` for Windows, and `cloud-0.sh` & `cloud-1.sh` for Linux Ubuntu, always gets installed and sets up the cloud computer for optimal general usage with Fractal. The scripts will update the OS, download all the relevant drivers and Fractal libraries and executables, and install the basic software required for rapid onboarding on a new cloud computer.

In addition to the OS-specific scripts, which install the minimum required to make Fractal work optimally, there are usage-specific scripts. These scripts can be run from the cloud scripts by specifying boolean toggles as parameters. Some of the softwares listed here cannot actually be installed through PowerShell/Bash, but are listed for potential manual install:

- PC Gaming Script
  - Nvidia GeForce (Windows only)
  - Steam 
  - Discord
  - Epic Games Launcher (Windows only)
  - GOG (Windows only)
  - Blizzard (Windows only)

- Creative Script
  - Blender
  - Autodesk Maya
  - ZBrush (can't be installed without a subscription)
  - Adobe Creative Cloud (can't be installed without a subscription)
  - Cinema4D
  - 3DS Max Design (can't be installed without a subscription)
  - DaVinci Resolve (can't be installed without a subscription)
  - Lightworks

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

- Data Science & Machine Learning Script
  - Git
  - Anaconda & R Studio
  - OpenCV

- Productivity Script
  - Slack
  - Microsoft Office Suite (Windows Only)
  - Adobe Acrobat Reader DC
  - Skype
  - Zoom

## Peer-to-Peer Setup Scripts

The general peer-to-peer scripts, `peer2peer.ps1` and `peer2peer.sh`, always gets installed and set up a user's local computer for streaming with Fractal. The scripts will mostly only install Fractal and set necessary drivers and firewall rules. 

All of these scripts are hosted in the Fractal AWS S3 bucket "fractal-cloud-setup-s3bucket" at https://s3.console.aws.amazon.com/s3/home?region=us-east-1 and should be replaced there when there is another change for release.
