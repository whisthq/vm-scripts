








cd %temp%
rmdir /S/Q fractal-protocol
mkdir fractal-protocol
cd fractal-protocol

powershell -command "iwr -outf version https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/version"
fc /b version "C:\Program Files\Fractal\version" > nul

if errorlevel 1 (
  move /Y version "C:\Program Files\Fractal"

  powershell -command "iwr -outf FractalServer.exe https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/FractalServer.exe"

  fc /b FractalServer.exe "C:\Program Files\Fractal\FractalServer.exe" > nul

  if errorlevel 1 (
    net stop Fractal
    taskkill /IM "FractalService.exe" /F
    taskkill /IM "FractalServer.exe" /F
    timeout /t 1
    move /Y FractalServer.exe "C:\Program Files\Fractal"
    net start Fractal
  )
)

cd C:\Program Files\Fractal
