# This script gets called by `general.ps1`
$script_name = "utils.psm1"
Import-Module "C:\Program Files\Fractal\$script_name"

Install-AdobePremiere
Install-DaVinciResolve
Install-Blender
Install-Lightworks