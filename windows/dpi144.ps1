# This script gets run (as Administrator) by a webserver to change the DPI on a Windows cloud computer

# Set DPI to 144
Write-Output "Change Windows DPI to enable 4K Streaming"
cd 'HKCU:\Control Panel\Desktop'
$val = Get-ItemProperty -Path . -Name "LogPixels"
Write-Host 'Change to 150% / 144 dpi'
Set-ItemProperty -Path . -Name LogPixels -Value 144
Set-ItemProperty -Path . -Name Win8DpiScaling 1

# All set
