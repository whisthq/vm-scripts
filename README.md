# Fractal Cloud Computer Setup Scripts

This repository contains the Fractal PowerShell scripts that get launched at creation of a cloud computer to set it up in a specific configuration. These scripts can be toggled from a selection on the Fractal website in the cloud computer creation page, and are then fed to the Azure SDK when the VM gets created. A combination of many scripts can be selected.

The general script, `general.ps1`, always gets installed and sets up the cloud computer for optimal general usage with Fractal. The following tasks are performed by the general script.





- Install Google Chrome
- 







The following usage-specific scripts are currently supported:

The following usage-specific scripts are yet to be supported:

- Gaming Script
  - Nvidia GeForce
  - Steam
  - Epic Games Launcher
  - 
  
  

- Creative Script - 2D Graphics
  - Photoshop
  - Adobe Illustrator
  -

- Creative Script - 3D Graphics
  - Blender
  - Maya
  - ZBrush
  -

- Creative Script - Video Editing
  - Adobe Premiere Pro
  - DaVinci Resolve
  -
  

- Software Development Script
  - Windows Developer Mode Turned On
  - Visual Studio Community 2019
  - Visual Studio Code
  - Git
  - Windows Subsystem for Linux
  - Chocolatey
  - Docker
  
  
  
- Data Science & Machine Learning Script
  - Windows Developer Mode Turned On
  - Anaconda
  - Git
  - Chocolatey
  - 
  
  

- Productivity Script
  - Microsoft Office Suite
  - Zoom Video Conferencing
  - 







