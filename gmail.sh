#!/bin/bash

#Works for Ubuntu
#Your Gmail account must have access to less secure apps!
#https://myaccount.google.com/lesssecureapps

if [[ $(whoami) != 'root' ]];
then
	echo -e "\e[91;1mYou must run script as root!\e[0m"
fi

if [[ $(ls ~/.msmtprc &> /dev/null && echo 1 || echo 0) == '0' ]];
then
	if [[ $(cat /etc/apt/sources.list | grep -q 'deb http://security.ubuntu.com/ubuntu trusty-security main universe' && echo 1 || echo 0) == '0' ]];
	then
		echo 'deb http://security.ubuntu.com/ubuntu trusty-security main universe' >> /etc/apt/source.list
		apt-get update
		apt-get install heirloom-mailx -y
	fi
	apt-get install msmtp-mta -y
	chmod 600 .msmtprc
	echo 'set sendmail="/usr/bin/msmtp"
set message-sendmail-extra-arguments="-a gmail"' >> ~/.mailrc
fi

funct_send(){
clear
printf "Your Gmail: "
read gmail
printf "\nYour Password: "
read -s password

if [[ $(curl -u $gmail:$password --silent "https://mail.google.com/mail/feed/atom" | grep -q Unauthorized && echo 1) == 1 ]];
then
	clear
	echo -e "\e[91;1mAuthorization Failed\e[0m"
	sleep 3
	funct_send
fi
}
funct_send
echo '#Gmail account
defaults
#change the location of the log file to any desired location.
logfile ~/msmtp.log
account gmail
auth on
host smtp.gmail.com
from '"$gmail"'
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
user '"$gmail"'
password '"$password"'
port 587
#set gmail as your default mail server.
account default : gmail' > ~/.msmtprc

printf "\n\nReceiver Gmail: "
read receiver
printf "\nSubject: "
read subject
printf "\n[0] Cancel\nAttachment: "
read attachment
if [[ $attachment == '0' ]];
then
	a=''
else
	a="-a$(echo $attachment)"
fi
printf "\nPress Ctrl+D to finish\nText:\n"
cat > message.txt
clear
cat message.txt | mail -s "$subject" "$a" $receiver &> /dev/null
printf "Message was sent to $receiver\n\n"
sleep 3
rm -rf message.txt
sed -i "s/$gmail/<yourmail@gmail.com>/g" ~/.msmtprc
sed -i "s/$password/<your-password>/g" ~/.msmtprc
