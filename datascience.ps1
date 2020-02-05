# The `general.ps1` script must be run before this script is run
$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Install-Git
Install-Anaconda
Install-CudaToolkit
Install-Pillow
Install-OpenCV
Install-Xgboost
Install-Caffe
Restart-Computer