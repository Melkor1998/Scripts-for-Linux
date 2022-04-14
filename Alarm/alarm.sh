#!/bin/bash

#Script is for debian/ubuntu but can be used for other distros if you change the way of downloading player on line 7
#We will use youtube-dl to download ringtone and MPV to play it

#PLAYER
funct_install_fordeb(){
sudo apt install mpv -y
}
funct_install_forcentos(){
sudo yum install wget -y
wget http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
sudo rpm -Uvh nux-dextop-release-0-5.el7.nux.noarch.rpm
sudo yum install mpv -y
rm -rf nux-dextop-release-0-5.el7.nux.noarch.rpm
}

which mpv || funct_install_fordeb || funct_install_forcentos || exit

#Alarm
funct_set(){
	time=$(date +%s)
	alarm2=$(date -d "$alarm" +%s)
	sleeptime=$(( $alarm2 - $time ))
	a=${sleeptime:0:1}

	if [[ $a == '-' ]];
	then
		alarm2=$(( $alarm2 + 86400 ))
	fi

	sleeptime=$(( $alarm2 - $time ))
	timeleft=$(date -d@$sleeptime -u +%H:%M:%S)
	realtime=$(date "+%H:%M:%S")
    	alarm=$(echo $alarm | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    	alarm=$(date -d@$alarm -u +%H:%M:%S)
}

funct_after(){
	time=$(date +%s)
	sleeptime=$(echo $sleeptime2 | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
	alarm2=$(( $time + $sleeptime + 14400 ))
	alarm=$(date -d@$alarm2 -u +%H:%M:%S)
}

funct_choose(){
    clear
    echo -e '\e[1m[1]\e[0m Set alarm at \e[92mH:M:S\e[0m
\e[1m[2]\e[0m Set alarm for after \e[92mH:M:S\e[0m

\e[91;1m[0]\e[0m\e[91m Exit\e[0m'
    read -s -n 1 choose
    if [[ $choose == '1' ]];
    then
    	clear
    	printf "Set alarm at: "
    	read alarm
    	clear
    	funct_set
    elif [[ $choose == '2' ]];
    then
    	clear
    	printf "Ring after: "
    	read sleeptime2
    	funct_after
    elif [[ $choose == '0' ]];
    then
    	clear; exit
    else
    	funct_choose
    fi
}

funct_choose

while [[ $sleeptime -gt '0' ]]
do
	clear
	sleeptime=$(( $sleeptime - 1 ))
	timeleft=$(date -d@$sleeptime -u +%H:%M:%S)
	echo -e "Will ring at  - $alarm"
	echo -e "Time now is   - $(date +"%H:%M:%S")"
	echo -e "Time left     - \e[92m$timeleft\e[0m"
	sleep 1
done

clear && echo -e "\nPRESS \e[91;1mq\e[0m TO STOP\n" && mpv --loop --no-video https://youtu.be/SmSeOMXIQ5U && clear
