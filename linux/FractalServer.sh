#!/bin/bash

export DISPLAY=$(systemctl --user show-environment | awk -F = '/DISPLAY/{print $2}')
export XAUTHORITY=$(systemctl --user show-environment | awk -F = '/XAUTHORITY/{print $2}')

./FractalServer

