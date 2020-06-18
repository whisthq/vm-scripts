#!/bin/bash

# Use this script to remotely run cloud-0.sh and cloud-1.sh to set up a Linux VM with Fractal
# This script needs to be run from a Linux computer

sudo echo "login"

if ! [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && ! [[ $2 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo "Usage: ./setup-linux.sh [IP ADDRESS] [VM/CONTAINER PASSWORD]"
	exit
fi

sudo apt install sshpass -y

sudo sshpass -p "$2" scp -o "StrictHostKeyChecking no" -r $PWD fractal@$1:~/fractal-setup

echo "Initializing Server"
echo "cd ~/fractal-setup; /bin/bash cloud-0.sh $2" | sudo sshpass -p "$2" ssh -o "StrictHostKeyChecking no" fractal@$1 /bin/bash

echo "Waiting for server to reboot..."
SSH_EXIT_STATUS=255

while [[ $SSH_EXIT_STATUS -eq 255 ]]; do
	echo "cd ~/fractal-setup; /bin/bash cloud-1.sh $2" | sudo sshpass -p "$2" ssh -o "StrictHostKeyChecking no" fractal@$1 /bin/bash
	SSH_EXIT_STATUS=$?
done

sudo ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"

echo "Removing ~/fractal-setup"
SSH_EXIT_STATUS=255

while [[ $SSH_EXIT_STATUS -eq 255 ]]; do
	echo "rm -rf ~/fractal-setup" | sudo sshpass -p "$2" ssh -o "StrictHostKeyChecking no" fractal@$1 /bin/bash
	SSH_EXIT_STATUS=$?
done
