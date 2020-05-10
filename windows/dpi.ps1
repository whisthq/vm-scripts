# This script gets run (as Administrator) by a webserver to update the DPI of a Windows VM
# It calls the respective DPI script
# Usage: run-dpi.ps1 ["DPI"]
param (
    [string]   $dpi = "96"
)

# Set the execution policy to enable running Powershell modules and scripts
Set-ExecutionPolicy RemoteSigned -Force

# Helper function to download the PowerShell scripts from S3 buckets
function GetPowerShellScript ($script_name, $script_url) {
    Write-Output "Downloading Powershell script $script_name from $script_url"
    [Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile($script_url, $script_name)
}

# set DPI to 96
if ($dpi == "96") {
    # fetch the script, run it and clean
    Write-Output "Setting DPI to 96 via dpi96.ps1 script"
    $script_name = "C:\dpi96.ps1"
    $script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/dpi96.ps1"
    GetPowerShellScript $script_name $script_url
    Start-Process Powershell.exe -Credential $credentials -ArgumentList ("-file $script_name") -Wait
    Write-Output "Cleaning up DPI script"
    Remove-Item -Path $script_name -Confirm:$false



# This script gets run (as Administrator) by a webserver to change the DPI on a Windows cloud computer

# Set DPI to 96
Write-Output "Change Windows DPI to enable 4K Streaming"
cd 'HKCU:\Control Panel\Desktop'
$val = Get-ItemProperty -Path . -Name "LogPixels"
Write-Host 'Change to 100% / 96 dpi'
Set-ItemProperty -Path . -Name LogPixels -Value 96
Set-ItemProperty -Path . -Name Win8DpiScaling 0
cd 'C:\Users\Fractal' # cd back

# All set






}
# set dpi to 144
else if ($dpi == "144") {
    # fetch the script, run it and clean
    Write-Output "Setting DPI to 96 via dpi144.ps1 script"
    $script_name = "C:\dpi144.ps1"
    $script_url = "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/dpi144.ps1"
    GetPowerShellScript $script_name $script_url
    Start-Process Powershell.exe -Credential $credentials -ArgumentList ("-file $script_name") -Wait
    Write-Output "Cleaning up DPI script"
    Remove-Item -Path $script_name -Confirm:$false


# This script gets run (as Administrator) by a webserver to change the DPI on a Windows cloud computer

# Set DPI to 144
Write-Output "Change Windows DPI to enable 4K Streaming"
cd 'HKCU:\Control Panel\Desktop'
$val = Get-ItemProperty -Path . -Name "LogPixels"
Write-Host 'Change to 150% / 144 dpi'
Set-ItemProperty -Path . -Name LogPixels -Value 144
Set-ItemProperty -Path . -Name Win8DpiScaling 1
cd 'C:\Users\Fractal' # cd back

# All set





}

# All set
