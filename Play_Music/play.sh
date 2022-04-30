#!/bin/bash

#You need to have ytfzf installed!
#Make alias for script in .bashrc for example alias play="~/play.sh" and run > play "musicname..."
#Script plays in mp3 format in terminal that means u can run and play it via ssh as well
music=$(echo $*)
ytfzf -L $music > link
clear
echo -e "\e[1mNow playing:\e[0m $(youtube-dl --skip-download --get-title --no-warnings $(cat link) 2> /dev/null)"
mpv --no-video $(cat link) || clear
rm -rf link
