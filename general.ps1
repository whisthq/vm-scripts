param (
    [string]        $admin_username = "Fractal",
    [SecureString]  $admin_password = "password1234567.",
    [switch]        $manual_install = $false
)

$script_name = "utils.psm1"
Import-Module "C:\$script_name"






Disable-ScheduleWorkflow
Disable-Devices
Disable-TCC
Enable-Audio
Install-VirtualAudio
Install-Steam
Add-AutoLogin $admin_username $admin_password
Restart-Computer