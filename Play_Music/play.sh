#!/bin/bash

#You need to have ytfzf installed!
#Make alias for script in .bashrc for example alias play="~/play.sh" and run > play "musicname..."
#Script plays in mp3 format in terminal that means u can run and play it via ssh as well
music=$(echo $*)
ytfzf -L $music > link
clear
echo -e "Link: $(cat link)"
mpv --no-video $(cat link) || clear
rm -rf link
