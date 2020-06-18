branch=$1

rm -rf /tmp/fractal-protocol
mkdir /tmp/fractal-protocol
cd /tmp/fractal-protocol

curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/version > version

v1=$(cat version)
v2=$(cat /usr/share/version)

if [ "$v1" -ne "$v2" ]
then
  curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/FractalServer > FractalServer
  curl https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/${branch}/Linux/update.sh > update.sh

  sudo -u fractal DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$FRACTAL_UID/bus systemctl --user stop fractal
  pkill FractalServer
  cp FractalServer /usr/share/fractal/FractalServer
  cp update.sh /usr/share/fractal/update.sh
  cp version /usr/share/version
  sudo -u fractal DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$FRACTAL_UID/bus systemctl --user start fractal
fi
