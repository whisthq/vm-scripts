# This script gets run (as Administrator) by a Fractal Cloud Computer to enable Cloud streaming
# This script should only get run on Windows computers
# This script is part 2 of 2, and gets run by cloud-0.ps1

# Show File Extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 | Out-Null

# Set Wallpaper
if((Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System") -eq $true) {} Else {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System" | Out-Null}
if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value Wallpaper) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name Wallpaper -PropertyType String -value "C:\Program Files\Fractal\Assets\wallpaper.png" | Out-Null}
if((Test-RegistryValue -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -value WallpaperStyle) -eq $true) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -value 2 | Out-Null} Else {New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name WallpaperStyle -PropertyType String -value 2 | Out-Null}

# All set, going back to cloud-1.ps1