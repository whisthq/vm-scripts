# This script should be run (as Administrator) first before any application-installer script
# TODO: change password to secure password
param (
    [string]        $admin_username = "Fractal",
    [SecureString]  $admin_password = (convertto-securestring "password1234567." -asplaintext -force),
    [switch]        $manual_install = $false
)

# TODO: Change to fixed path & get the file downloaded on VM
$script_name = "C:\users\phili\Downloads\fractal-setup-scripts\utils.psm1"
Import-Module "$script_name"

##Update-Windows
##Update-Firewall
##Disable-TCC
##Enable-Audio
##Install-VirtualAudio
##Install-Chocolatey
##Install-Steam
##Install-GoogleChrome
##Install-EpicGamesLauncher
##Install-Blizzard
##Install-Git









#Set-Wallpaper

Install-OpenCV


#Install-AdobeAcrobat

#Install-AdobePhotoshop
#Install-AdobeIllustrator
#Install-NvidiaGeForce

#Install-Blender
#Install-AutodeskMaya
#Install-ZBrush
#Install-AdobeAnimate
#Install-Cinema4D
#Install-3DSMaxDesign

#Install-AdobePremiere
#Install-DaVinciResolve
#Install-Blender
#Install-Lightworks




#Install-Office
#Install-Zoom
#Install-Skype
#Install-Anaconda
#Install-CudaToolkit
#Install-Pillow
#Install-OpenCV
#Install-Caffe

#Enable-DeveloperMode
#Install-VS2019
#Install-VSCode
#Install-WSL
#Install-Atom
#Install-Docker

#Install-Spotify
#Install-GOG
#Install-Blizzard





#Install-Blender


#Install-GOG

#Disable-ScheduleWorkflow
#Disable-Devices






#Add-AutoLogin $admin_username $admin_password
##Restart-Computer