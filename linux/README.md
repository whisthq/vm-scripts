# Fractal Linux Ubuntu Setup Scripts

This subfolder is responsible for all the Linux-related system scripts to set up a computer, virtual machine or container for Fractal streaming.

### Linux Ubuntu Cloud Scripts

There are two Linux cloud scripts, `cloud-0.sh` and `cloud-1.sh`, which both need to be run one after another, since the packages installed in `cloud-0.sh` require rebooting. The cloud scripts can be run both locally via SSH with X redirection (`ssh -X`) or via a webserver. The following tasks are performed by the cloud scripts:

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
- Disable Automatic Lock Screen

You can simply run `./setup-linux.sh [IP ADDRESS]` to run those two scripts on a specific VM/container from any device.

### Linux Ubuntu Peer-to-Peer Scripts

There is one Linux Ubuntu peer-to-peer script, `peer2peer.sh`, which gets run locally by the Fractal client application. The following tasks are performed by the peer-to-peer script:

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
