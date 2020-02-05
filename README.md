# Fractal Cloud Computers Setup Scripts

This repository contains the Fractal PowerShell scripts that get launched at creation of a cloud computer to set it up in a specific configuration. These scripts can be toggled from a selection on the Fractal website in the cloud computer creation page, and are then fed to the Azure SDK when the VM gets created. A combination of many scripts can be selected.

The general script, `general.ps1`, always gets installed and sets up the cloud computer for optimal general usage with Fractal. The following tasks are performed by the general script.

- Update Windows
- Update Firewall to allow ICMP pings
- Disable Tesla TCC mode to enable Tesla Graphics (WDM mode)
- Enable Audio by autostarting the Audio service
- Set Automatic Time & Timezone
- Install the Virtual Audio Driver
- Install Chocolatey for easy Windows packages installation
- Install Google Chrome
- Install Spotify
- Install Tesla Nvidia Public Drivers
- Install 7zip
- Install DirectX
- Install .Net Framework (>3.5)
- Install Fractal
- Set Fractal Wallpaper








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
  - ZBrush
  - Adobe Creative Cloud
  - Cinema4D
  - 3DS Max Design
  - DaVinci Resolve
  - Lightworks

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
  - Cuda Toolkit
  - OpenCV
  
- Productivity Script
  - Microsoft Office
  - Adobe Acrobat
  - Skype
  - Zoom

*Once we have a solid customer base, it could be valuable to have companies pay us to have their software installed by default on Fractal cloud computers.
