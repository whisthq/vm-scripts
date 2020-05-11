# Fractal Windows Setup Scripts

This subfolder is responsible for all the Windows-related system scripts.

## Windows DPI Scripts

The DPI script `dpi.ps1` is meant to be called from a webserver, along with the argument `96` or `144` depending on the respective DPI to set. It will use Remote-PowerShell to change the DPI of any windows VM or computer.

Usage: ```run-dpi.ps1 "96"``` or ```run-dpi.ps1 "144"```

### Windows Cloud Scripts

There is one Windows cloud script, `cloud.ps1`, which can be run both locally from a PowerShell terminal within RDP, or via a webserver. The following tasks are performed by the cloud script:

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
- Set Automatic Time & Timezone
- Disable Network Window since always connected via Ethernet
- Show File Extensions
- Set the Windows DPI to 150% to enable 4K Streaming
- Install 7-Zip
- Install Spotify
- Install Google Chrome
- Install Nvidia Tesla Public Drivers (in addition to GRID drivers, includes Cuda Toolkit 10.2)
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
- Disable Shutdown, Logout and Sleep in Start Menu
- Set Auto-Login

### Windows Peer-to-Peer Scripts

There is one Windows peer-to-peer script, `peer2peer.ps1`, which gets run locally by the Fractal client application. The following tasks are performed by the peer-to-peer script:

- Update Firewall to allow ICMP pings
- Download and Enable the Fractal service
- Download the Fractal server executable
- Download the Fractal Exit script
- Download the Fractal auto update script
- Enable Fractal Firewall Rules
- Download the Unison File Sync executable
- Enable the OpenSSH Server for File Sync
