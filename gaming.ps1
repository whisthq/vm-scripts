# The `general.ps1` script must be run before this script is run
$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Install-NvidiaGeForce
Install-Steam
Install-EpicGamesLauncher
Restart-Computer