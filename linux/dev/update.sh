branch=$1

rm -rf /tmp/fractal-protocol
mkdir /tmp/fractal-protocol
cd /tmp/fractal-protocol

curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/version > version

v1=$(cat version)
v2=$(cat /usr/share/version)

if [ "$v1" -ne "$v2" ]
then
  # download Fractal server, service and custom FFmpeg libs
  curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/FractalServer > FractalServer
  curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/update.sh > update.sh
  curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/fractal.service > fractal.service
  curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/FractalServer.sh > FractalServer.sh
  curl https://fractal-protocol-shared-libs.s3.amazonaws.com/shared-libs.tar.gz | tar -xz
  
  # stop the Fractal service and server
  sudo -u fractal DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$FRACTAL_UID/bus systemctl --user stop fractal
  pkill FractalServer

  # swap everything out back into the Fractal folder
  cp FractalServer /usr/share/fractal/FractalServer
  cp update.sh /usr/share/fractal/update.sh
  cp version /usr/share/version
  cp FractalServer.sh /usr/share/fractal/FractalServer.sh
  cp fractal.service /usr/share/fractal/fractal.service
  cp share/64/Linux/* /usr/share/fractal/

  # restart the Fractal service
  sudo -u fractal DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$FRACTAL_UID/bus systemctl --user start fractal
fi

rm -rf /tmp/fractal-protocol
