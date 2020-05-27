#!/bin/bash

sudo echo login

if ! [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo "Usage: ./setup-linux.sh [IP ADDRESS]"
	exit
fi

sudo apt install sshpass -y

sshpass -p "password1234567." scp  -o "StrictHostKeyChecking no" -r linux Fractal@$1:~/fractal-setup
echo "cd ~/fractal-setup; /bin/bash cloud-0.sh" | sshpass -p "password1234567." ssh -o "StrictHostKeyChecking no" Fractal@$1 /bin/bash
echo "Waiting for server to reboot..."
SSH_EXIT_STATUS=255
while [[ $SSH_EXIT_STATUS -eq 255 ]]; do
	echo "cd ~/fractal-setup; /bin/bash cloud-1.sh" | sshpass -p "password1234567." ssh -o "StrictHostKeyChecking no" Fractal@$1 /bin/bash
	SSH_EXIT_STATUS=$?
	echo "SSH: $SSH_EXIT_STATUS"
done
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"
