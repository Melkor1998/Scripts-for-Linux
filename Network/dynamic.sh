#!/bin/bash

#run as sudo, using in linuxmint

inter=$(ip link show | grep 'state UP' | cut -d':' -f2 | xargs)
ifconfig enp3s0 0.0.0.0 0.0.0.0 && dhclient
ifconfig $inter down
ifconfig $inter up
systemctl restart NetworkManager.service
