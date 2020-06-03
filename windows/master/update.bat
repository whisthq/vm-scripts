cd %temp%
rmdir /S/Q fractal-protocol
mkdir fractal-protocol
cd fractal-protocol
echo %1%

set file=%1%

IF NOT "%~1" == "" (
  set file=%1%/
)

powershell -command "iwr -outf version https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/%file%version"
fc /b version "C:\Program Files\Fractal\version" > nul

if errorlevel 1 (
  move /Y version "C:\Program Files\Fractal"

  powershell -command "iwr -outf FractalServer.exe https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/%file%FractalServer.exe"
  
  net stop Fractal
  taskkill /IM "FractalService.exe" /F
  taskkill /IM "FractalServer.exe" /F
  timeout /t 1
  del /F "C:\Program Files\Fractal\FractalServer.exe"
  timeout /t 1
  move /Y FractalServer.exe "C:\Program Files\Fractal"
  sc.exe Start "Fractal"
)

cd C:\Program Files\Fractal
