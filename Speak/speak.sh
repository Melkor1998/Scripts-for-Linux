#!/bin/bash

ffmpeg -version &> /dev/null || sudo apt install ffmpeg -y
which terminator &> /dev/null || sudo apt install terminator -y
which mpv &> /dev/null || sudo apt install mpv -y
which arecord &> /dev/null || sudo apt install alsa-utils -y
funct_speak(){
read words
rm -rf voice.mp3
terminator -x "sleep 1; espeak -g1 \"$words\"; sleep 1; pkill -9 arecord; mpv voice.mp3; exit"
arecord voice.mp3
}
printf 'Write: '
funct_speak &> /dev/null
printf "\e[91;1m --->  \e[0mFile location: $(pwd)/$(ls voice.mp3)\n\e[91;1m --->\e[0m$(ffmpeg -i voice.mp3 2>&1 | grep Duration), size: $(ls -sh voice.mp3 | awk '{print $1}')\n"
