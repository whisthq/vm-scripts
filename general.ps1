# This script should be run first before any application-installer script
param (
    [string]        $admin_username = "Fractal",
    [SecureString]  $admin_password = "password1234567.",
    [switch]        $manual_install = $false
)

$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Update-Windows
Update-Firewall
Disable-TCC
Enable-Audio
Install-VirtualAudio
Install-Chocolatey






Disable-ScheduleWorkflow
Disable-Devices












Add-AutoLogin $admin_username $admin_password
Restart-Computer