# This script should be run first before any application-installer script
param (
    [string]        $admin_username = "Fractal",
    [SecureString]  $admin_password = (convertto-securestring "password1234567." -asplaintext -force),
    [switch]        $manual_install = $false
)

$script_name = "C:\users\phili\Downloads\fractal-setup-scripts\utils.psm1"
Import-Module "$script_name"

##Install-Chocolatey
##Install-Steam
##Install-GoogleChrome
##Install-EpicGamesLauncher







#Update-Windows
#Update-Firewall
#Disable-TCC
#Enable-Audio
#Install-VirtualAudio
#Install-Blizzard




#Install-GOG

#Disable-ScheduleWorkflow
#Disable-Devices












#Add-AutoLogin $admin_username $admin_password
#Restart-Computer