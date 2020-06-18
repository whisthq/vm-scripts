#!/bin/bash

export DISPLAY=$(systemctl --user show-environment | awk -F = '/DISPLAY/{print $2}')
export XAUTHORITY=$(systemctl --user show-environment | awk -F = '/XAUTHORITY/{print $2}')

# attempt to launch the server
./FractalServer

# if error --> 2 == No such file or directory
if [ "$?" == "2" ]; then
    echo "Downloading Fractal Server & Auto-update Script"
    sudo wget -qO /usr/share/fractal/FractalServer "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/master/FractalServer"
    sudo wget -qO /usr/share/fractal/update.sh "https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/master/update.sh"

    sudo chmod g+x /usr/share/fractal/FractalServer # make FractalServer executable
        ./FractalServer # attempt to launch again

fi
