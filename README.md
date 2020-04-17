# Fractal Computers Setup Scripts

This repository contains the Fractal PowerShell and Bash scripts that get launched at creation of a cloud computer to set it up in a specific configuration, or when a user sets up their personal computer for peer-to-peer streaming. The cloud scripts can be toggled from a selection on the Fractal website in the cloud computer creation page, and are then fed to the Azure SDK when the VM gets created. A combination of many scripts can be selected.

## Cloud Setup Scripts

The general cloud scripts, `cloud.ps1` and `cloud.sh`, always gets installed and sets up the cloud computer for optimal general usage with Fractal. The following tasks are performed by the general scripts:

### Windows Cloud Computers
- Update Windows
- Update Firewall to allow ICMP pings
- Install Chocolatey for easy Windows packages installation
- Install Visual C++ Redistribuable for Windows C++ libraries (vcruntime140.dll, etc.)
- Install .Net Framework (4.7)
- Install DirectX
- Install the Virtual Audio Driver
- Enable Audio by Autostarting the Audio service
- Enable Accessibility Mouse Keys
- Set Mouse Pointer Precision
- Set Automatic Time & Timezone
- Disable Network Window since always connected via Ethernet
- Show File Extensions
- Install 7-Zip
- Install Spotify
- Install Google Chrome
- Install Nvidia Tesla Public Drivers (in addition to GRID drivers, includes Cuda Toolkit 10.2)
- Disable Tesla TCC mode to enable Tesla Graphics (WDM mode)
- Set Optimal Tesla M60 GPU Settings
- Install Posh-SSH to SSH via PowerShell
- Disable Hyper-V Video (to use the GPU instead, will fail if you're using RDP when running the script)
- Create Fractal Directory in Program Files
- Download and Enable the Fractal service
- Download the Fractal server executable
- Enable Fractal Firewall Rules
- Download the Fractal Exit script
- Download the Fractal auto update script
- Download & Set the Fractal wallpaper
- Download the Unison File Sync executable
- Enable the OpenSSH Server for File Sync
- Disable Shutdown, Logout and Sleep in Start Menu
- Set Auto-Login

There are two scripts, `cloud-0.ps1` and `cloud-1.ps`, with `cloud-1.ps1` being run by `cloud-0.ps1`. After running `cloud-0.ps1`, dotnetfx won't be fully installed (1 package will be missing), the Fractal disconnect button won't be pinned to the Start Menu and the Display settings won't be greyed-out. To have those features, you need to log back on the cloud computer via RDP and do the following:
- Open PowerShell and run "choco install dotnetfx --force
- Open Start Menu, right-click "_Exit Fractal_" and select "Pin to Start"
- Open "Local Group Policy Editor", naviguate to \User Configuration\Administrative Tools\Control Panel\Display and set both the settings listed there (Disable the Display Control Panel, Hide Settings tab) to "Enabled"

### Linux Ubuntu Cloud Computers
- Update Linux
- Set Automatic Time & Timezone
- Install 7-Zip
- Install Spotify
- Install Google Chrome
- Install Nvidia Tesla Public Drivers (in addition to GRID drivers, includes Cuda Toolkit 10.2)
- Disable Tesla TCC mode to enable Tesla Graphics (WDM mode)
- Set Optimal Tesla M60 GPU Settings
- Install Gnome and Dummy Virtual Display
- Set Custom Gnome Display Manager Configuration
- Set Custom X11 Resolution Configuration
- Create Fractal Directory in /usr/share/
- Download and Enable the Immortal Process Manager
- Download the Fractal server executable
- Enable Fractal Firewall Rules
- Download the Fractal Exit script
- Download the Fractal auto update script
- Download & Set the Fractal wallpaper
- Download the Unison File Sync executable
- Download & Enable the Fractal Input Driver
- Enable the SSH Server for File Sync (SSH Automatically Enabled on Linux)
- Disable Shutdown in Start Menu
- Set Auto-Login

There are two scripts to run, `cloud-0.sh` and `cloud-1.sh`, since installing Gnome requires a reboot. After running `cloud-0.sh` and `cloud-1.sh`, auto-login won't be set. To have this feature, you need to log onto the cloud computer via Fractal and do the following:
- Click on the down arrow in the top-right corner -> Click "Fractal" (the user) -> Select "Account Settings"
- Click "Unlock" in the top-right of the window that opened, and enter the VM password (`password1234567.`) -> Set Automatic Login toggle to "On"

The following usage-specific scripts are currently supported, although some of the softwares listed here cannot actually be installed through PowerShell/Bash, but are listed for potential manual install:

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

- Software Development Script
  - Windows Developer Mode Activated (Windows only)
  - Visual Studio Professional 2019 (Windows Only)
  - Visual Studio Code
  - Git
  - Windows Subsystem for Linux (Windows only)
  - Atom
  - Docker

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

The general peer-to-peer scripts, `peer2peer.ps1` and `peer2peer.sh`, always gets installed and sets up a user's local computer for streaming with Fractal. The following tasks are performed by the general script:

### Windows Computers

- Update Firewall to allow ICMP pings
- Download and Enable the Fractal service
- Download the Fractal server executable
- Download the Fractal Exit script
- Download the Fractal auto update script
- Enable Fractal Firewall Rules
- Download the Unison File Sync executable
- Enable the OpenSSH Server for File Sync

### Linux Ubuntu Computers

- Set Custom Gnome Display Manager Configuration
- Set Custom X11 Resolution Configuration
- Create Fractal Directory in /usr/share/
- Download and Enable the Immortal Process Manager
- Download the Fractal server executable
- Enable Fractal Firewall Rules
- Download the Fractal Exit script
- Download the Fractal auto update script
- Download the Unison File Sync executable
- Download & Enable the Fractal Input Driver
- Enable the SSH Server for File Sync (SSH Automatically Enabled on Linux)

All of these scripts are hosted in the Fractal AWS S3 bucket "fractal-cloud-setup-s3bucket" at https://s3.console.aws.amazon.com/s3/home?region=us-east-1 and should be replaced there when there is another change for release.
