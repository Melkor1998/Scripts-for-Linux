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
clear

#Alarm
printf "Set alarm to: "
read alarm
clear
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
