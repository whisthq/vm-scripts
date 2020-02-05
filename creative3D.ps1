# The `general.ps1` script must be run before this script is run
$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Install-Blender
Install-AutodeskMaya
Install-ZBrush
Install-AdobeAnimate
Install-Cinema4D
Install-3DSMaxDesign
Restart-Computer