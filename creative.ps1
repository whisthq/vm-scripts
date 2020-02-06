# This script gets called by `general.ps1`
$script_name = "utils.psm1"
Import-Module "C:\Program Files\Fractal\$script_name"

Install-Blender
Install-AutodeskMaya
Install-ZBrush
Install-Cinema4D
Install-3DSMaxDesign
Install-AdobeCreativeCloud
Install-DaVinciResolve
Install-Lightworks