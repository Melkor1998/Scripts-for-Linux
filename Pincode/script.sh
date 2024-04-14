#!/bin/bash

funct_pincode(){
printf 'Enter 4 digit pincode: '
read -n4 pincode
if [[ $pincode =~ ^[0-9]+$ ]];
then
	clear
	echo "Proccess will begin"
	sleep 1
	funct_findout
else
	clear
	echo -e "\e[91mEnter only 4 digit pincode\e[0m"
fi
funct_pincode
}

funct_findout(){
clear
echo -e "\e[91m"
for i in {0000..9999}; do echo "$i"; 
	if [ $i -eq $pincode ];
	then
		clear
		echo -e "\e[0m\e[92m$i is your pincode\e[0m"
		exit
	fi
	sleep 0.0001
	clear
done
}

funct_pincode
