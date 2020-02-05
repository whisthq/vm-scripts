# This script gets called by `general.ps1`
$script_name = "utils.psm1"
Import-Module "C:\Program Files\Fractal\$script_name"

Install-Git
Install-Anaconda
Install-CudaToolkit
Install-Pillow
Install-OpenCV
Install-Caffe