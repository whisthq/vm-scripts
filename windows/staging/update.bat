cd %temp%
rmdir /S/Q fractal-protocol
mkdir fractal-protocol
cd fractal-protocol
echo %1%

set branch=%1%

IF "%~1" == "" (
  set branch=master
)

powershell -command "iwr -outf version https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/%branch%/Windows/version"
fc /b version "C:\Program Files\Fractal\version" > nul

if errorlevel 1 (
  net stop Fractal
  taskkill /IM "FractalService.exe" /F
  taskkill /IM "OldFractalService.exe" /F
  taskkill /IM "FractalServer.exe" /F

  curl -s "https://fractal-protocol-shared-libs.s3.amazonaws.com/shared-libs.tar.gz" | tar xzf -
  xcopy /e /Y /c share\64\Windows\* "C:\Program Files\Fractal"
  del /F share

  copy /Y "C:\Program Files\Fractal\FractalService.exe" "C:\Program Files\Fractal\OldFractalService.exe"
  sc config Fractal binPath="\"C:\Program Files\Fractal\OldFractalService.exe\""
  powershell -command "iwr -outf FractalService.exe https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/%branch%/Windows/FractalService.exe"
  move /Y FractalService.exe "C:\Program Files\Fractal"
  sc config Fractal binPath="\"C:\Program Files\Fractal\FractalService.exe\""

  del /F "C:\Program Files\Fractal\OldFractalService.exe"

  del /F "C:\Program Files\Fractal\FractalServer.exe"
  powershell -command "iwr -outf FractalServer.exe https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/%branch%/Windows/FractalServer.exe"
  move /Y FractalServer.exe "C:\Program Files\Fractal"

  move /Y version "C:\Program Files\Fractal"

  sc Start "Fractal"
)

cd C:\Program Files\Fractal
