#!/bin/bash

#Script is for debian/ubuntu but can be easily modified for other distros, it's the matter of ringtone
#We will use youtube-dl to download ringtone and MPV to play it

#RINGTONE
which youtube-dl &> /dev/null || sudo apt install youtube-dl; clear
if [[ $(ls ~/'Cool Ringtone-SmSeOMXIQ5U.mp3' | rev | cut -d'/' -f1 | rev) != 'Cool Ringtone-SmSeOMXIQ5U.mp3' ]];
then
	which youtube-dl &> /dev/null || sudo apt install youtube-dl
	cd ~
	clear
	#We need ffmpeg to download file as mp3
	apt install ffmpeg; clear
	echo -e "\e[91mPlease wait... We need ringtone for alarm to work\e[0m"
	youtube-dl --extract-audio --audio-format mp3 https://youtu.be/SmSeOMXIQ5U
fi

#PLAYER
which mpv &> /dev/null || sudo apt install mpv

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
}

funct_after(){
	time=$(date +%s)
	sleeptime=$(echo $sleeptime2 | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
#    c=$(date -d "$(date +%H:%M:%S)" +%s)
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

clear && echo -e "\nPRESS \e[91;1mq\e[0m TO STOP\n" && mpv --loop ~/'Cool Ringtone-SmSeOMXIQ5U.mp3' && clear
