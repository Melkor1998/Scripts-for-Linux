#!/bin/bash

#FOR CENTOS 7

clear
echo -e "\nსკრიპტი უნდა გაეშვას სუდოთი"
sudo echo "" || exit

#sudo yum install nfs-* &> /dev/null
#systemctl enable rpcbind &> /dev/null
#systemctl enable nfs-server &> /dev/null
#systemctl enable nfs-lock &> /dev/null
#systemctl enable nfs-idmap &> /dev/null
#systemctl start rpcbind &> /dev/null
#systemctl start nfs-server &> /dev/null
#systemctl start nfs-lock &> /dev/null
#systemctl start nfs-idmap &> /dev/null

#firewall-cmd --permanent --zone=public --add-service=nfs &> /dev/null
#firewall-cmd --permanent --zone=public --add-service=mountd &> /dev/null
#firewall-cmd --permanent --zone=public --add-service=rpc-bind &> /dev/null
#firewall-cmd --reload &> /dev/null


##################################################################################################
# S E R V E R
##################################################################################################

#1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

function_s_folder(){
read -sn 1 -p "
#1# Share Folder

[1]. შექმენი ფოლდერი გაზიარებისთვის
[2]. არსებული ფოლდერის გამოყენება






< [8]. უკან გადასვლა          [9]. წინ გადასვლა >

X [0]. გამოსვლა

შენი ფოლდერი: "
clear
if [ ${REPLY} = 1 ]; then
	echo -e "\nდაწერე რელატიური მისამართი ფოლდერის შექმნისთვის"
	read s_folder
	clear
elif [ ${REPLY} = 2 ]; then
	echo -e "\nდაწერე რელატიური მისამართი არსებული ფოლდერის"
	read s_folder
	clear
	ls $s_folder &> /dev/null && function_s_ip || echo -n "WARNING!!! ეგეთი ფოლდერი არ არსებობს!" && s_folder=" " && function_s_folder
elif [ ${REPLY} = 8 ]; then
	clear
	function_Welcome
elif [ ${REPLY} = 9 ]; then
	clear
	function_s_ip
elif [ ${REPLY} = 0 ]; then
	clear
	echo -e "გამოსვლა\n"
	exit
else
	clear
	echo -n "WARNING!!! პასუხი არასწორია!"
	function_s_folder
fi
function_s_ip
}

#222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222

function_s_ip(){
clear
read -sn 1 -p "
#2# Client IP

[1] ჩაწერე კლიენტის IP







< [8]. უკან გადასვლა          [9]. წინ გადასვლა >

X [0]. გამოსვლა
" s_ip
clear

if [ $s_ip = 1 ]; then
	clear
	printf 'კლიენტის IP: '
	read key_s_ip
	clear
elif [ $s_ip = 8 ]; then
	clear
	function_s_folder
elif [ $s_ip = 9 ]; then
	clear
	function_s_yesno
elif [ $s_ip = 0 ]; then
	clear
	echo -e "გამოსვლა\n"
	exit
else
	function_s_ip
	clear
fi
function_s_yesno
}

#3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333

function_s_yesno(){
clear

read -sn 1 -p "
#3# Finish

ფოლდერი რომელიც გაზიარდება: $s_folder
კლიენტის მისამართი: $key_s_ip






< [8]. უკან გადასვლა          [1]. შესრულება >

X [0]. გამოსვლა

"

if [ ${REPLY} = 1 ]; then
	clear
	ls $s_folder &> /dev/null || mkdir $s_folder &> /dev/null
	echo "$s_folder $key_s_ip(rw,sync,no_root_squash)" >> /etc/exports && exportfs -arv
	function_Welcome
elif [ ${REPLY} = 8 ]; then
	clear
	function_s_ip
elif [ ${REPLY} = 0 ]; then
	clear
	echo -e "გამოსვლა\n"
fi
function_Welcome
}

##################################################################################################
# C L I E N T
##################################################################################################

function_Server_IP(){
clear
read -sn 1 -p "
#1# Server IP

[1.] ჩაწერე სერვერის IP







< [8]. უკან გადასვლა          [9]. წინ გადასვლა >

X [0]. გამოსვლა
" server_ip

if [ $server_ip = 1 ]; then
	clear
	printf "სერვერის IP: "
	read key_server_ip
	clear
elif [ $server_ip = 8 ]; then
    clear
    function_Welcome
elif [ $server_ip = 9 ]; then
    clear
    function_Server_Folder
elif [ $server_ip = 0 ]; then
	clear
    echo -e "გამოსვლა\n"
    exit
else
    clear
    function_Server_IP
fi
function_Server_Folder
}

#22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222

function_Server_Folder(){
read -sn 1 -p "
#2# Server Folder

[1] ჩაწერე სერვერის ფოლდერი რომლითაც გაგიზიარებენ სივრცეს და მიამაგრებ შენთან







< [8]. უკან გადასვლა          [9]. წინ გადასვლა >

X [0]. გამოსვლა
" server_folder
clear
if [ $server_folder = 1 ]; then
	clear
	printf "სერვერის ფოლდერი:"
	read key_server_folder
	clear
elif [ $server_folder = 8 ]; then
    clear
    function_Server_IP
elif [ $server_folder = 9 ]; then
    clear
    function_Client_Folder
elif [ $server_folder = 0 ]; then
	clear
    echo -e "გამოსვლა\n"
    exit
else
    clear
    key_server_folder=$(echo $server_folder)
fi
function_Client_Folder
}

#3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333

function_Client_Folder(){
read -sn 1 -p "
#3# Client Folder

[1]. შექმენი ფოლდერი რაზეც მიმაგრდება სერვერის ფოლდერი სივრცის გაზიარების მიზნით
[2]. უკვე არსებული ფოლდერის გამოყენება მისამაგრებლად






< [8]. უკან გადასვლა          [9]. წინ გადასვლა >

X [0]. გამოსვლა
"
clear

if [ ${REPLY} = 1 ]; then
	echo -e "\nმიუთითე ფოლდერის რელატიური მისამართი შექმნისთვის\n"
	read client_folder
    clear
elif [ ${REPLY} = 2 ]; then
	echo -e "\nმიუთითე არსებული ფოლდერი\n"
	read client_folder
    clear
    ls $client_folder &> /dev/null && function_Client_yesno || echo -n "WARNING!!! ფოლდერი არ არსებობს!" && client_folder=" " && function_Client_Folder
elif [ ${REPLY} = 8 ]; then
    clear
    function_Server_Folder
elif [ ${REPLY} = 9 ]; then
	clear
    function_Client_yesno
elif [ ${REPLY} = 0 ]; then
	clear
	echo -e "გამოსვლა\n"
	exit
else
	clear
    echo -n "WARNING!!! პასუხი არასწორია!"
    function_Client_Folder
fi
function_Client_yesno
}

#44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444

function_Client_yesno(){
echo -e "\n#4# Finish\n"
echo -e "\nსერვერის მისამართი: $key_server_ip"
echo -e "სერვერის ფოლდერი: $key_server_folder"
echo -e "გაზიარდება შენს ფოლდერში: $client_folder\n"
read -sn 1 -p "


< [8]. უკან გადასვლა          [1]. შესრულება

X [0]. გამოსვლა
"

if [ ${REPLY} = 1 ]; then
	ls $client_folder &> /dev/null || mkdir -p $client_folder &> /dev/null
	clear
	mount $key_server_ip:$key_server_folder $client_folder && echo -n "ფოლდერის მიმაგრება შესრულდა წარმატებით!" || echo -n "WARNING!!! ფოლდერი ვერ მიმაგრდა, უშედეგო მცდელობა!"
    function_Welcome
elif [ ${REPLY} = 8 ]; then
    clear
	function_Client_Folder
elif [ ${REPLY} = 0 ]; then
	clear
	echo -e "გამოსვლა\n"
	exit
else
    clear
	echo -n "WARNING!!! პასუხი არასწორია!"
    function_Client_yesno
fi
}

##################################################################################################
##################################################################################################

function_ALL_Server(){
	function_s_folder
	function_s_ip
	function_s_yesno
}

function_ALL_Client(){
	function_Server_IP
	function_Server_Folder
	function_Client_Folder
	function_Client_yesno
}

##################################################################################################
##################################################################################################

function_Welcome() {
clear
read -sn 1 -p "
Welcome to NFS script!

[1]. სერვერის მხარე
[2]. კლიენტის მხარე

[0]. გამოსვლა

"

if [ ${REPLY} = 1 ]; then
	clear
	function_ALL_Server
elif [ ${REPLY} = 2 ]; then
	clear
	function_ALL_Client
elif [ ${REPLY} = 0 ]; then
	clear
	echo -e "გამოსვლა\n"
	exit
else
	echo -e "\nპასუხი არასწორია!\n"
fi
}

function_Welcome
