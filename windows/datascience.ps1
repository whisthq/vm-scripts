# Helper script to install data science applications
$script_name = "utils.psm1"
Import-Module "C:\$script_name"

Enable-DeveloperMode
Install-Git
Install-Anaconda
Install-OpenCV
Install-Curl
Install-Gimp
