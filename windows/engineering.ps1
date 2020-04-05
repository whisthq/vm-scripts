# This script gets called by `general.ps1`
$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Install-Solidworks
Install-Fusion360
Install-Matlab