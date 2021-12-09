#!/bin/bash

#FOR DEBIAN/UBUNTU

bold="\e[1m"
red="\e[91m"
boldred="\e[1;91m"
end="\e[0m"

funct_menu(){
	echo -e "
Choose the number

$bold[1]$end Update
$bold[2]$end Upgrade
$bold[3]$end Fix packets
$bold[4]$end Remove useless packets

$boldred[0]$end$red Quit$end
	"
}

funct_menu2(){
	echo -e "\n$bold[Enter]$end Back to list\n\n    \e$boldred[0]$end$red Quit$end"
}

funct_aftermenu2(){
	if [ ${REPLY} = $(Enter) ]; then
		clear
		funct
	elif [ ${REPLY} = 0 ]; then
		clear
	else
		funct_wronginmenu2
	fi
}

funct_forParrot(){
	if [ $(lsb_release -a 2> /dev/null | sed -n '1p' | awk 'NF{print $NF}') = "Parrot" ]; 
	then
		clear
		echo -e "Full Upgrade\n"
		sudo apt full-upgrade
	else
		clear
		sudo apt upgrade
	fi
}

funct_wronginmenu2(){
	clear
	echo -en $red$bold"Wrong input!$end"
	funct_menu2
	sleep 1
	clear
	funct_menu2
	read -s -n 1
	funct_aftermenu2
}

funct(){
funct_menu
read -s -n 1
if [ ${REPLY} = 1 ]; then
	clear
	sudo apt update
	funct_menu2
	read -s -n 1
	funct_aftermenu2
elif [ ${REPLY} = 2 ]; then
	funct_forParrot
	funct_menu2
	read -s -n 1
	funct_aftermenu2
elif [ ${REPLY} = 3 ]; then
	clear
	sudo apt install -f
	funct_menu2
	read -s -n 1
	funct_aftermenu2
elif [ ${REPLY} = 4 ]; then
	clear
	sudo apt autoremove
	funct_menu2
	read -s -n 1
	funct_aftermenu2
elif [ ${REPLY} = 0 ]; then
	clear
else
	clear
	echo -en $red"Wrong input!$end"
	funct_menu
	sleep 1
	clear
	funct
fi
}

clear
funct
