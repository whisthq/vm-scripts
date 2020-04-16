# This script gets called by `general.ps1`
$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Install-GeForceExperience
Install-Steam
Install-Discord
Install-EpicGamesLauncher
Install-GOG
Install-Blizzard
