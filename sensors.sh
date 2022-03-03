#!/bin/bash

#Tested on LinuxMint

#You must allow "less secure app access" to your gmail account, orelse script won't be able to authorize and can't show ur inbox

which sensors || sudo apt install sensors -y
which espeak || sudo apt install espeak -y
funct_login(){
clear
printf "username: "
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
	if [[ $b -gt 0 ]];
	then
		x='\e[91;1m'
		y='\e[0m'
	else
		x=''
		y=''
	fi
	printf "\nGmail notifications: $x$b$y\n"
	printf "\e[91;1m"
	#curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++    ) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p"
	printf "$c"
	printf "\e[0m"
	a=$(curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++    ) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p")
	b=$(curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++    ) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p" | wc -l)
	if [[ $(echo $a | grep -q '-' && echo 1) -eq '1' ]];
	then
	c=$(curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++    ) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p")
		espeak "You got mailed"
	else
		c=''
	fi
	sleep 1
}
while :
do
	funct_sensors
done
