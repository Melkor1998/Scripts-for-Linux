#!/bin/bash

#run as sudo, using in linuxmint

inter=$(ip link show | grep 'state UP' | cut -d':' -f2 | xargs)
network=$(ifconfig | grep -A2 "$inter" | grep "inet " | sed 's/^ *//g' | sed -n 1p)
ifconfig enp3s0 0.0.0.0 0.0.0.0 && dhclient
ifconfig $inter $network
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
