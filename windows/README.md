# Fractal Windows Scripts

This subfolder is responsible for all the Windows-related system scripts to set up a computer, virtual machine or container for Fractal streaming.

## Windows Cloud Scripts

Usage: `cloud.ps1 [VM/CONTAINER PASSWORD] [[OPTIONAL] PROTOCOL-BRANCH]`

There is one Windows cloud script, `cloud.ps1`, which can be run both locally from a PowerShell terminal directly in the VM via Microsoft RDP, or via a webserver sendng remote tasks to the VM/container. 

For VMs, we prepare specific base disks which we clone for production users, so these only need to be run once to format the base disk, while for containers we have base images pre-built. On Windows cloud computers and containers, the username is set to `Fractal` for every single cloud computer. The following tasks are performed by the cloud script:

- Update Windows
- Update Firewall to allow ICMP pings
- Install Chocolatey for easy Windows packages installation
- Install Visual C++ Redistribuable for Windows C++ libraries (vcruntime140.dll, etc.)
- Install .Net Framework (4.7)
- Install DirectX
- Enable Remote PowerShell
- Install the Virtual Audio Driver
- Enable Audio by Autostarting the Audio service
- Enable Accessibility Mouse Keys
- Set Mouse Pointer Precision
- Disable Network Window since always connected via Ethernet
- Show File Extensions
- Install 7-Zip
- Install Nvidia Tesla Public Drivers (This step is skipped, as it overrides the Azure GRID driver required for 4K resolution)
- Disable Tesla TCC mode to enable Tesla Graphics (WDM mode)
- Set Optimal Tesla M60 GPU Settings
- Install Curl
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
- Disable UAC to avoid Administrators prompts
- Disable Shutdown, Logout and Sleep in Start Menu
- Set Auto-Login (This step is skipped, and is instead ran by the main-webserver to set a user-specific VM password)

## Windows Peer-to-Peer Scripts

There is one Windows peer-to-peer script, `peer2peer.ps1`, which gets run locally by the Fractal client application. The following tasks are performed by the peer-to-peer script:

- Update Firewall to allow ICMP pings
- Download and Enable the Fractal service
- Download the Fractal server executable
- Download the Fractal Exit script
- Download the Fractal auto update script
- Enable Fractal Firewall Rules
- Download the Unison File Sync executable
- Enable the OpenSSH Server for File Sync

## Windows DPI Scripts

The DPI script `dpi.ps1` is meant to be called from a webserver, along with the argument `96` or `144` depending on the respective DPI to set. It will use Remote-PowerShell to change the DPI of any Windows VM or computer.

Usage: ```dpi.ps1 96 [VM/CONTAINER PASSWORD]``` or ```dpi.ps1 144 [VM/CONTAINER PASSWORD]```
