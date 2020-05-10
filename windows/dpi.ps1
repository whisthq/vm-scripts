# This script gets run (as Administrator) by a webserver to update the DPI of a Windows VM
# Usage: run-dpi.ps1 ["DPI"]
param (
    [string]        $admin_username = "Fractal",
    [SecureString]  $admin_password = (ConvertTo-SecureString "password1234567." -AsPlainText -Force),
    [SecureString]  $certificate_password = (ConvertTo-SecureString "certificate-password1234567." -AsPlainText -Force),
    [string]        $dpi = "96"
)

# Set the execution policy to enable running Powershell modules and scripts
Set-ExecutionPolicy RemoteSigned -Force

# Helper function to download the PowerShell scripts from S3 buckets
function Get-PowerShellScript ($script_name, $script_url) {
    Write-Output "Downloading Powershell script $script_name from $script_url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile($script_url, $script_name)
}

# Download utils PowerShell script with helper functions and import it, and download cloud-1.ps1
$utils_script_name = "C:\utils.psm1"
$utils_script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/utils.psm1"
Get-PowerShellScript $utils_script_name $utils_script_url
Import-Module "$utils_script_name"

# Make sure we're in the proper directory (mostly for running from webservers) and define credentials for user
cd C:\
$credentials = New-Object System.Management.Automation.PSCredential $admin_username, $admin_password

# set DPI to 96
if ($dpi == "96") {
    Write-Output "Change Windows DPI to 100% / 96 DPI"
    $command = 'Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name LogPixels -Value 96
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Win8DpiScaling 0'  
    Invoke-RemotePowerShellCommand $credentials $command        
}
# set dpi to 144
else if ($dpi == "144") {
    Write-Output "Change Windows DPI to 150% / 144 DPI"
    $command = 'Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name LogPixels -Value 144
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Win8DpiScaling 1'  
    Invoke-RemotePowerShellCommand $credentials $command 
}

# Clean PowerShell install script and restart
Write-Output "Cleaning up Utils script script"
Remove-Item -Path $utils_script_name -Confirm:$false
Restart-Computer -Force
