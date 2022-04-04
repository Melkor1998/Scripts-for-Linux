#!/bin/bash

#You need to have ytfzf installed!
#Make alias for script in .bashrc for example alias play="~/play.sh" and run > play "musicname..."
#Script plays in mp3 format that means u can run it via ssh as well
music=$(echo $*)
ytfzf -L $music > link
clear
echo -e "\e[1mNow playing:\e[0m $(youtube-dl --skip-download --get-title --no-warnings $(cat link) 2> /dev/null)"
mpv --no-video --force-seekable=yes $(cat link) || clear && echo "Error"
rm -rf link
