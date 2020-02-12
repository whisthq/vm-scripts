# This script gets called by `general.ps1`
$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Enable-DeveloperMode
Install-VS2019
Install-VSCode
Install-Git
Install-WSL
Install-Atom
Install-Docker