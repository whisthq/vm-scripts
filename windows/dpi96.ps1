# This script gets run (as Administrator) by a webserver to change the DPI on a Windows cloud computer

# Set DPI to 96
Write-Output "Change Windows DPI to enable 4K Streaming"
cd 'HKCU:\Control Panel\Desktop'
$val = Get-ItemProperty -Path . -Name "LogPixels"
Write-Host 'Change to 100% / 96 dpi'
Set-ItemProperty -Path . -Name LogPixels -Value 96
Set-ItemProperty -Path . -Name Win8DpiScaling 0

# All set
