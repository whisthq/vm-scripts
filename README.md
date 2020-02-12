# Fractal Cloud Computers Setup Scripts

This repository contains the Fractal PowerShell scripts that get launched at creation of a cloud computer to set it up in a specific configuration. These scripts can be toggled from a selection on the Fractal website in the cloud computer creation page, and are then fed to the Azure SDK when the VM gets created. A combination of many scripts can be selected.

The general script, `master.ps1`, always gets installed and sets up the cloud computer for optimal general usage with Fractal. When you run the PowerShell script initially on a VM from the PowerShell prompt (as-opposed to loading it directly in the Azure VM creation), you might get an access denied error. If this is the case, run `Set-ExecutionPolicy RemoteSigned` and retry. The following tasks are performed by the general script:

- Update Windows
- Update Firewall to allow ICMP pings
- Install Chocolatey for easy Windows packages installation
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
- Disable Hyper-V Video (to use the GPU instead, will fail if you're using RDP when running the script)
- Create Fractal Directory in Program Files
- Download & Enable the Fractal service
- Download the Fractal server executable
- Download & Set the Fractal wallpaper
- Enable Fractal Firewall Rules
- Disable Shutdown, Logout and Sleep in Start Menu
- Set Auto-Login

The following usage-specific scripts are currently supported, although some of the softwares listed here cannot actually be installed through PowerShell, but are listed for potential manual-install:

- PC Gaming Script
  - Nvidia GeForce
  - Steam
  - Epic Games Launcher
  - GOG
  - Blizzard

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
  - Autodesk Fusion 360
  - Matlab (can't be installed without a subscription)

- Software Development Script
  - Windows Developer Mode Activated
  - Visual Studio Community 2019
  - Visual Studio Code
  - Git
  - Windows Subsystem for Linux
  - Atom
  - Docker
    
- Data Science & Machine Learning Script
  - Git
  - Anaconda & R Studio
  - OpenCV

- Productivity Script
  - Microsoft Office Suite
  - Adobe Acrobat Reader DC
  - Skype
  - Zoom
  
  All of these scripts are hosted in the Fractal AWS S3 bucket "fractal-cloud-setup-s3bucket" at https://s3.console.aws.amazon.com/s3/home?region=us-east-1 and should be replaced there when there is another change for release.
