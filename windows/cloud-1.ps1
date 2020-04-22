# This script gets run (as Administrator) by a Fractal Cloud Computer to enable Cloud streaming
# This script should only get run on Windows computers
# This script is part 2 of 2, and gets run by cloud-0.ps1

# Helper function to verify registry
function Test-RegistryValue {
    # https://www.jonathanmedd.net/2014/02/testing-for-the-presence-of-a-registry-key-and-value.html
    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Value
    )
    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Show File Extensions
Write-Output "Setting File Extensions"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 | Out-Null

# Set Wallpaper
Write-Output "Setting Fractal Wallpaper"
if((Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value Wallpaper) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -PropertyType String -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null}
if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value WallpaperStyle) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -value 2 | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -PropertyType String -value 2 | Out-Null}

# Set DPI
Write-Output "Change Windows DPI to enable 4K Streaming"
cd 'HKCU:\Control Panel\Desktop'
$val = Get-ItemProperty -Path . -Name "LogPixels"
Write-Host 'Change to 150% / 144 dpi'
Set-ItemProperty -Path . -Name LogPixels -Value 144
Set-ItemProperty -Path . -Name Win8DpiScaling 1

# All set, going back to cloud-0.ps1
