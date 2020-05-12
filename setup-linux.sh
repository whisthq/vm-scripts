#!/bin/bash

sudo echo login

if ! [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo "Usage: ./setup-linux.sh [IP ADDRESS]"
	exit
fi

echo "rm -rf ~/fractal-setup" | ssh Fractal@$1 /bin/bash
scp -r linux Fractal@$1:~/linux
echo "cd ~/fractal-setup; /bin/bash linux/cloud-0.sh" | ssh Fractal@$1 /bin/bash
sleep 30
echo "cd ~/fractal-setup; /bin/bash linux/cloud-1.sh" | ssh Fractal@$1 /bin/bash
ssh-keygen -f "/home/npip99/.ssh/known_hosts" -R "$1"

