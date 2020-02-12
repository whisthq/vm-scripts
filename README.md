# Fractal Cloud Computers Setup Scripts

This repository contains the Fractal PowerShell scripts that get launched at creation of a cloud computer to set it up in a specific configuration. These scripts can be toggled from a selection on the Fractal website in the cloud computer creation page, and are then fed to the Azure SDK when the VM gets created. A combination of many scripts can be selected.

The general script, `master.ps1`, always gets installed and sets up the cloud computer for optimal general usage with Fractal. When you run the PowerShell script initially on a VM from the PowerShell prompt (as-opposed to loading it directly in the Azure VM creation), you might get an access denied error. If this is the case, run `Set-ExecutionPolicy RemoteSigned` and retry. The following tasks are performed by the general script:

- Update Windows
- Update Firewall to allow ICMP pings
- Install Chocolatey for easy Windows packages installation
- Install .Net Framework (4.7)
- Install DirectX
- Install the Virtual Audio Driver







- Install Nvidia Tesla Public Drivers (in addition to GRID drivers, includes Cuda Toolkit 10.2)
- Disable Tesla TCC mode to enable Tesla Graphics (WDM mode)
- Set Optimal Tesla M60 GPU Settings
- Enable Audio by autostarting the Audio service
- Set Automatic Time & Timezone
- Enable the Fractal Service
- Enable Fractal Firewall Rules
- Install Google Chrome
- Install Spotify
- Install Tesla Nvidia Public Drivers
- Install 7zip
- Create Fractal Directory in Program Files
- Install Fractal & Create Desktop Shortcut
- Set Fractal Wallpaper
- Set Automatic Time & Timezone
- Disable Network Window since always connected via Ethernet
- Set Mouse Pointer Precision
- Enable Accessibility Mouse Keys
- Show File Extensions
- Disable Hyper-V Video (to use the GPU instead)
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
  - Microsoft Office Suite
  - Adobe Acrobat Reader DC
  - Skype
  - Zoom
