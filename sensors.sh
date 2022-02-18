#!/bin/bash

#You must allow "less secure app access" to your gmail account, orelse script won't be able to authorize and can't show ur inbox

which sensors || sudo apt install sensors -y
which espeak || sudo apt install espeak -y
funct_login(){
clear
printf "Username: "
read username
printf "Password: "
read -s password
if [[ $(curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | grep -q Unauthorized && echo 1) == 1 ]];
then
	clear
	echo -e "\e[91;1mAuthorization Failed\e[0m"
	sleep 3
	funct_login
fi
}
funct_login
funct_sensors(){
	clear
	sensors
	printf "Time: \e[1m$(date +"%I:%M")\e[0m\n"
	printf "\nGmail notifications\n"
	printf "\e[91;1m"
	curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++    ) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p" || exit
	printf "\e[0m"
	a=$(curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++    ) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p")
	if [[ $(echo $a | grep -q '-' && echo 1) -eq '1' ]];
	then
		espeak "You got mailed"
	fi
	sleep 1
}
while :
do
	funct_sensors
done
