#!/bin/bash

# Script is dedicated for CentOS 7, also works for AlmaLinux
# სკრიპტი განკუთვნილია CentOS 7 სისტემისთვის, ასევე მუშაობს AlmaLinux-ზეც

# მინიმალურ ვერსიაში ifconfig ბრძანება არაა ჩაშენებული, ქვემოთა ბრძანებების ხაზი უზრუნველყოფს რო ბრძანება ifconfig ხელმისაწვდომი იყოს
ifconfig &> /dev/null || yum install net-tools -y &> /dev/null

yum list installed | grep '^bind\|^bind-utils*' &> /dev/null
if [[ $? -ne 0 ]];
then
	bindd=0
	y='\e[91;5;1mBind not detected!\e[0m'
else
	bindd=1
	y=''
fi

clear

#FIREWALL
sudo enable firewalld &> /dev/null
sudo start firewalld &> /dev/null
sudo firewall-cmd --zone=public -permanent --add-service=dns &> /dev/null
sudo firewall-cmd --zone=public --permanent --add-service=rpc-bind &> /dev/null
sudo firewall-cmd --permanent --add-port=53/tcp --zone=public &> /dev/null

ip=$(ifconfig | sed -n "2p" | cut -d" " -f10)

a=$(cat /etc/named.conf | wc -l)
b=$[ $a - 4 ]

date=$(date +"%d%m%Y")

### ფუნქცია listen-on port-ის სექციისთვის
funct_listen-on(){
	echo -e "1. მისამართის ჩაწერა (listen-on port)
2. წაშლა

8. უკან დაბრუნება

\e[91m0. გამოსვლა\e[0m"

	read -s -n 1

	if [[ $REPLY == 1 ]];
	then
		clear
		printf "\nჩაწერე მისამართი: "

		read listenon

		# თუ არ წერია ის რაც გვჭირდება ჩაწეროს
		if [[ $(cat /etc/named.conf | grep listen-on | grep -q $listenon && echo 1 || echo 0) == '0' ]];
		then
			sed -i "s/\(listen-on port 53 {\)/\1 $listenon;/i" /etc/named.conf
		# თუ უკვე წერია ის რაც გვჭირდება შეგვატყობინოს
		elif [[ $(cat /etc/named.conf | grep listen-on | grep -q $listenon && echo 1 || echo 0) == '1' ]];
		then
			funct_check
			clear
			echo -e "\e[91;1mმითითებული მისამართი listenon port ჩანაწერში უკვე არსებობს\e[0m"
			funct_listen-on
		fi
	elif [[ $REPLY == 2 ]];
	then
		clear
		sed -i 's/.*listen-on port 53.*/\tlisten-on port 53 { 127.0.0.1; };/' /etc/named.conf
		funct_check
		funct_menu
	elif [[ $REPLY == 8 ]];
	then
		clear
		funct_menu
	elif [[ $REPLY == 0 ]];
	then
		clear
		exit
	else
		clear
		funct_listen-on
	fi
	clear
	funct_check
	funct_menu
}

### ფუნქცია allow-query სექციისთვის
funct_allow-query(){
	echo -e "1. მისამართის ჩაწერა (allow-query)
2. წაშლა

8. უკან დაბრუნება

\e[91m0. გამოსვლა\e[0m"

	read -s -n 1

	if [[ $REPLY == 1 ]];
	then
		clear
		printf "\nჩაწერე მისამართი: "

		read allowquery

		# თუ არ წერია ის რაც გვჭირდება ჩაწეროს
		if [[ $(cat /etc/named.conf | grep allow-query | grep -q $allowquery && echo 1 || echo 0) == '0' ]];
		then
			sed -i "s/\(allow-query     {\)/\1 $allowquery;/i" /etc/named.conf
		# თუ უკვე წერია ის რაც გვჭირდება შეგვატყობინოს
		elif [[ $(cat /etc/named.conf | grep allow-query | grep -q $allowquery && echo 1 || echo 0) == '1' ]];
		then
			funct_check
		        clear
	                echo -e "\e[91;1mმითითებული მისამართი allow-query ჩანაწერში უკვე არსებობს\e[0m"
	                funct_allow-query
		fi
	elif [[ $REPLY == 2 ]];
	then
		clear
		sed -i 's/.*allow-query.*/\tallow-query     { localhost; };/' /etc/named.conf
		funct_check
		funct_menu
	elif [[ $REPLY == 8 ]];
	then
		clear
		funct_menu
	elif [[ $REPLY == 0 ]];
	then
		clear
		exit
	else
		funct_allow-query
	fi
	clear
	funct_check
	funct_menu
}

### ფუნქცია allow-transfer-ისთვის
funct_allow-transfer(){
	echo -e "1. მისამართის ჩაწერა (allow-transfer)
2. წაშლა

8. უკან დაბრუნება

\e[91m0. გამოსვლა\e[0m"

	read -s -n 1

	if [[ $REPLY == '1' ]]; 
	then
		clear
    		printf "\nჩაწერე მისამართი: "

    		read allowtransfer

		# თუ allow transfer-ის ჩანაწერი არ არსებობს, შექმნას ჩანაწერი და მიუთითოს ის რაც გვჭირდება
		if [[ $(cat /etc/named.conf | grep -q 'allow-transfer' && echo 1 || echo 0) == 0 ]];
		then
			sed -i "/allow-query/ s/$/\n\tallow-transfer\t{ $allowtransfer; };/" /etc/named.conf
			funct_check
			clear
			funct_menu
		# თუ allow transfer ჩანაწერი არსებობს და უკვე მითითებულია ის რაც გვჭირდება, შეგვატყობინოს
		elif [[ $(cat /etc/named.conf | grep 'allow-transfer' | grep -q $allowtransfer && echo 1 || echo 0) == 1 ]];
		then
			funct_check
			clear
			echo -e "\e[91;1mმითითებული მისამართი allow-transfer ჩანაწერში უკვე არსებობს\e[0m"
			funct_allow-transfer
	   	# თუ allow transfer ჩანაწერი უკვე არსებობს და არ წერია ის რაც გვჭირდება, ჩაწეროს
		elif [[ $(cat /etc/named.conf | grep 'allow-transfer' | grep -q $allowtransfer && echo 1 || echo 0) == 0 ]];
		then
			sed -i "s/\(allow-transfer\t{\)/\1 $allowtransfer;/i" /etc/named.conf
		fi
	elif [[ $REPLY == 2 ]];
	then
		if [[ $(cat /etc/named.conf | grep -q 'allow-transfer' && echo 1 || echo 0) == 0 ]];
		then
			funct_check
			clear
			echo -e "\e[91;1mallow-transfer ჩანაწერი არ არსებობს\e[0m"
			funct_allow-transfer
		elif [[ $(cat /etc/named.conf | grep -q 'allow-transfer' && echo 1 || echo 0) == 1 ]];
		then
			clear
			sed -i '/\tallow-transfer/d' /etc/named.conf
			funct_check
			funct_menu
		fi
	elif [[ $REPLY == 8 ]]; 
	then
		clear
		funct_menu
	elif [[ $REPLY == 0 ]];
	then
		clear
		exit
	else
		clear
		funct_allow-transfer
	fi
	clear
	funct_check
	funct_menu
}

### ფუნქცია მთავარი DNS-თვის, ns1-ის ჩანაწერი
funct_ns1(){
	echo -e "1. ns1-ის ჩანაწერის გაკეთება
2. ns1-ის ჩანაწერის წაშლა

8. უკან დაბრუნება

\e[91m0.გამოსვლა\e[0m"

        read -s -n 1

        if [[ $REPLY == 1 ]];
        then
                clear
	elif [[ $REPLY == 2 ]];
	then
		clear
		printf "\nმაგალითი 'ns1.itvet05.ge'\nჩაწერე საიტის სახელი ns1-ისთვის: "

		read dsitens1

		dmidnamens1=$(echo $dsitens1 | cut -d"." -f2)
		dnamens1=$(echo $dsitens1 | cut -d"." -f2-3)
		if [[ $dsitens1 == $(cat /var/named/$dmidnamens1.db | grep NS | awk '{print $2}' | sed 's/.$//') ]];
		then
			clear

                        ip1=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f1)
                        ip2=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f2)
                        ip3=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f3)
                        ip4=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f4)
                        reversezone=$(echo "$ip3.$ip2.$ip1.in-addr.arpa")

			sed -i "/zone \"$dnamens1\" IN {/,+5d" /etc/named.conf
			sed -i "/zone \"$reversezone\" IN {/,+5d" /etc/named.conf
			rm -rf /var/named/$dmidnamens1.db /var/named/reverse.$dmidnamens1.db
			clear
			sitens1=""
			funct_check
			funct_menu
		else
			clear
			echo -e "\e[91;1mმითითებული ns1 არ არსებობს\e[0m"
			funct_ns1
		fi
	elif [[ $REPLY == 8 ]];
	then
		clear
		funct_menu
	elif [[ $REPLY == 0 ]];
	then
		clear
		exit
        else
                clear
                funct_ns1
        fi
	# თუ ns1 არ არსებობს
	if [[ $(cat /var/named/*.db | grep -q ns1 && echo 1 || echo 0) == '0' ]]; 
	then
		clear
		printf "\nმაგალითი 'ns1.itvet05.ge'\nჩაწერე საიტის სახელი ns1-ისთვის: "

		read sitens1

		# თუ მითითებული ns1 უკვე არსებობს
		if [[ $(cat /etc/named.conf | grep -q $sitens1 && echo 1 || echo 0) = 1 ]]; 
		then
			clear
			echo -e "\e[91;1mმითითებული ns1 საიტი უკვე არსებობს კონფიგურაციაში!\e[0m"
			funct_ns1
		# შექმნას ns1 თავისი db ფაილებით
		elif [[ $(cat /etc/named.conf | grep -q $sitens1 && echo 1 || echo 0) = 0 ]]; 
		then
			# ns1 ზონა
			# ns1-ის სახელი თავსართის და ბოლოსართის გარეშე
			namens1=$(echo $sitens1 | cut -d"." -f2)
			# ns1-ის სახელი თავსართის გარეშე
			zonens1=$(echo $sitens1 | cut -d"." -f2-3)		
			sed -i "$b a \\\nzone \"$zonens1\" IN {\n\ttype master;\n\tfile \"$namens1\.db\";\n\tallow-update {none;};\n};" /etc/named.conf
			# ns1-ის DB ფაილი
			cp /var/named/named.empty /var/named/$namens1\.db
			sed -i "4,7s/;/\t;/" /var/named/$namens1\.db
			sed -i "3s/0/$date/" /var/named/$namens1\.db
			sed -i "2s/@ rname.invalid./@ root.$sitens1./" /var/named/$namens1\.db
			sed -i "/NS\t@/c\\\t\tNS\t$sitens1." /var/named/$namens1\.db
			sed -i "/\tA\t/c$sitens1.\tA\t$ip" /var/named/$namens1\.db
			sed -i "10d" /var/named/$namens1\.db
			chown :named /var/named/$namens1\.db
			# ვაკეთებთ 4 ცვლადს, თითო ცვლადს უკავია ჩვენი IP მისამართის თითო ოქტეტა (3 ცვლადს გამოვიყენებთ რევერსის ზონის სახელის ჩასაწერად, მე-4 ცვლადს კი რევერსის db ფაილში PTR-ის სექციაში)
			ip1=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f1)
			ip2=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f2)
			ip3=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f3)
			ip4=$(ifconfig | sed -n "2p" | cut -d" " -f10 | cut -d"." -f4)
			# ns1-ის რევერსის ზონა
			reversezone=$(echo "$ip3.$ip2.$ip1.in-addr.arpa")
			sed -i "$b a \\\nzone \"$reversezone\" IN {\n\ttype master;\n\tfile \"reverse.$namens1\.db\";\n\tallow-update {none;};\n};" /etc/named.conf
			# ns1-ის რევერსის db ფაილი
			cp /var/named/named.loopback /var/named/reverse.$namens1.db
			sed -i "4,7s/;/\t;/" /var/named/reverse.$namens1.db
			sed -i "3s/0/$date/" /var/named/reverse.$namens1.db
			sed -i "2s/@ rname.invalid./@ root.$sitens1./" /var/named/reverse.$namens1.db
			sed -i "/NS\t@/c\\\tNS\t$sitens1." /var/named/reverse.$namens1.db
			sed -i "9,10d" /var/named/reverse.$namens1.db
			sed -i "9s/\tPTR\tlocalhost./$ip4\tPTR\t$sitens1./" /var/named/reverse.$namens1.db
			chown :named /var/named/reverse.$namens1.db
		fi
	else
		clear
		echo -e "\e[91mns1 ჩანაწერი უკვე არსებობს\e[0m"
		funct_menu
	fi
	systemctl restart named
	funct_check
	funct_menu
}

### საიტის სექცია
funct_site(){
	echo -e "1. Site ჩანაწერის გაკეთება
2. Site ჩანაწერის წაშლა

8. უკან დაბრუნება

\e[91m0.გამოსვლა\e[0m"
read -s -n 1
	if [[ $REPLY == 1 ]];
	then
		#თუ ns1 არ არსებობს, არ შექმნას საიტი დომეინის გარეშე
		if [[ $(cat /var/named/*.db | grep -q "ns1" && echo 1 || echo 0) == 0 ]];
		then
		        clear
		        echo -e "\e[91;1mns1 არ არსებობს!\e[0m"
		        funct_site
		fi

		clear
		printf "\nმაგალითი 'satesto123.ge'\nჩაწერე საიტის სახელი: "

		read site

		# თუ მითითებული საიტი არსებობს, შეგვატყობინოს
		if [[ $(cat /etc/named.conf | grep -q $site && echo 1 || echo 0) = 1 ]]; 
		then
			clear
	    		echo -e "\e[91;1mმითითებული საიტი უკვე არსებობს კონფიგურაციაში!\e[0m"
			funct_site
		# თუ არ არსებობს, შექმნას
		elif [[ $(cat /etc/named.conf | grep -q $site && echo 1 || echo 0) = 0 ]]; 
		then
			namesite=$(echo $site | cut -d"." -f1)
			# კონფიგურაში ზონის ჩაწერა
			sed -i "$b a \\\nzone \""$site"\" IN {\n\ttype master;\n\tfile \"$namesite\.db\";\n\tallow-update {none;};\n};" /etc/named.conf
			# db ფაილის შექმნა
			cp /var/named/named.empty /var/named/$namesite.db
			sed -i "4,7s/;/\t;/" /var/named/$namesite.db
			sed -i "3s/0/$date/" /var/named/$namesite.db
			sed -i "2s/@ rname.invalid./@ root.$sitens1/" /var/named/$namesite.db
			sed -i "/NS\t@/c\\\tNS\t$sitens1" /var/named/$namesite.db
			sed -i "/\tA\t/c@\tA\t$ip" /var/named/$namesite.db
			sed -i "10d" /var/named/$namesite.db
			chown :named /var/named/$namesite.db
			echo -e "www\tCNAME\t@" >> /var/named/$namesite.db
		fi
		systemctl restart named
		funct_check
		clear
		funct_menu
	elif [[ $REPLY == 2 ]];
	then
		clear
		printf "\nმაგალითი 'satesto123.ge'\nჩაწერე საიტის სახელი: "

		read dsite

		dmidnamesite=$(echo $dsite | cut -d"." -f1)
		# წავშალოთ DB ფაილი
		if [[ $(ls /var/named/$dmidnamesite.db &> /dev/null && echo 1 || echo 0) == 1 ]];
		then
			rm -rf /var/named/$dmidnamesite.db
			clear
			funct_check
		fi
		# წავშალოთ named.conf ჩანაწერიდან
		if [[ $(sed -n "/$dsite/ {n;p}" /etc/named.conf | awk '{print $2}' | sed 's/.$//') == 'master' ]];
		then
			clear
			sed -i "/zone \"$dsite\" IN {/,+5d" /etc/named.conf
			funct_check
		fi		
		funct_menu
	elif [[ $REPLY == 8 ]];
	then
		clear
		funct_check
		funct_menu
	fi
}

# ფუნქცია რომელიც საშუალებას მოგვცემს bind-ის წაშლა/ჩაწერისთვის
funct_x(){
	clear
	if [[ $bindd == 0 ]];
	then
		yum install bind bind-utils -y
		bindd=1
		y=''
		x='\e[91;1m9. Remove bind\e[0m'
		clear
	        echo -en "\e[96;1mbind and bind-utils has been installed\e[0m"
        	funct_menu 2> /dev/null
	elif [[ $bindd == 1 ]];
	then
		cd
		rm -rvf /etc/named.conf /var/named/* && yum remove bind* -y
		bindd=0
		x='\e[96m9. Install bind\e[0m'
		clear
		echo -en "\e[91;1;5mbind has been deleted\e[0m"
        	funct_menu 2> /dev/null
	fi
}

### Slave ჩანაწერის სექცია
funct_slave(){
	echo -e "\n1. Slave ჩანაწერის გაკეთება\n2. Slave ჩანაწერის წაშლა\n\n3. უკან დაბრუნება\n\n\e[91;1m0. გამოსვლა\e[0m"

	read -s -n 1

	if [[ $REPLY == 1 ]];
	then
		clear
		masterip="?"
		slavesite="?"
		funct_slave2(){
		echo -e "\n1. მასტერის (ns1-ის) IP მისამართი\t-> \e[96;1m$masterip\e[0m\n2. Slave საიტის სახელი\t\t\t-> \e[96;1m$slavesite\e[0m\n\n3. უკან დაბრუნება\n\n4. შექმნა"

		read -s -n 1

		if [[ $REPLY == 1 ]];
		then
			clear
			printf "ჩაწერე IP მისამართი: "
			read masterip
			clear
			funct_slave2
		elif [[ $REPLY == 2 ]];
		then
			clear
			printf "ჩაწერე Slave სახელი: "
			read slavesite
			midnameslavesite=$(echo $slavesite | cut -d"." -f1)
			if [[ $(cat /etc/named.conf | grep -q "$slavesite" && echo 1) == 1 ]];
			then
				clear
				echo -e "\e[91;1mმითითებული საიტი დაფიქსირდა ჩანაწერში\e[0m"
				slavesite="\e[91;1m?\e[0m"
				funct_slave2
			fi
			if [[ $(ls /var/named/$midnameslavesite.db &> /dev/null && echo 1) == 1 ]];
			then
				clear
				echo -e "\e[91;1mმითითებული საიტის სახელით დაფიქსირებულია ფაილი ფოლდერში /var/named\e[0m"
				slavesite="\e[91;1m?\e[0m"
				funct_slave2
			fi
			clear
			funct_slave2
		elif [[ $REPLY == 3 ]];
		then
			clear
			masterip="?"
			slavesite="?"
			funct_slave
		elif [[ $REPLY == 4 ]];
		then
			clear
			if [[ $masterip == "?" ]];
			then
				clear
				echo -e "\e[91;1mშეავსეთ ორივე მოცემულობა\e[0m"
				funct_slave2
			fi
			if [[ $slavesite == "?" ]];
			then
                                clear
                                echo -e "\e[91;1mშეავსეთ ორივე მოცემულობა\e[0m"
                                funct_slave2
			fi
			
			if [[ $masterip != "" ]] && [[ $slavesite != "" ]];
			then
				clear				
				sed -i "$b a \\\nzone \"$slavesite\" IN {\n\ttype slave;\n\tfile \"slaves/$midnameslavesite\.db\";\n\tmasters { $masterip; };\n};" /etc/named.conf
				systemctl restart named
				funct_menu
			fi
		else
			clear
			funct_slave2
		fi
			
		}
		funct_slave2
	elif [[ $REPLY == 2 ]];
	then
		funct_slavedel(){
		printf "\nჩაწერე Slave სახელი: "

		read dslavesite

		dmidnameslave=$(echo $dslavesite | cut -d"." -f1)
		if [[ $(sed -n "/$dslavesite/ {n;p}" /etc/named.conf | awk '{print $2}' | sed 's/.$//') == 'slave' ]]
		then
			clear
			sed -i "/zone \"$dslavesite\" IN {/,+5d" /etc/named.conf
			rm -rf /var/named/slaves/$dmidnameslave.db &> /dev/null
			funct_check
			funct_menu
		elif [[ $(sed -n "/$dslavesite/ {n;p}" /etc/named.conf | awk '{print $2}' | sed 's/.$//') != 'slave' ]]
		then
			clear
			echo -e "\e[91;1mეგეთი Slave საიტი არ არსებობს\e[0m"
			funct_slave
		else
			funct_slavedel
		fi
		}
		funct_slavedel
	elif [[ $REPLY == 3 ]];
	then
		clear
		funct_check
		funct_menu
	elif [[ $REPLY == 0 ]];
	then
		clear
		exit
	else
		clear
		funct_slave
	fi
}

### WEB ##############################################################
funct_web(){
funct_web2(){
	printf "\n1. Web საიტის შექმნა\n2. Web საიტის წაშლა\n\n3. უკან დაბრუნება"

	read -s -n 1

	# უკან დაბრუნება
	if [[ $REPLY == 3 ]];
	then
		clear
		funct_menu
	#წაშლა
	elif [[ $REPLY == 2 ]];
	then
		funct_choosedwebname(){
		printf "\nჩაწერე საიტის სახელი (www-ს გარეშე): "

		read dwebsite

		if [[ $(ls /var/www/ | grep -q "$dwebsite" && echo 1 || echo 0) == 0 ]];
	        then
	                clear
	                printf "\e[31;1mეგეთი საიტი არ არსებობს\e[0m"
	                funct_choosedwebname
		fi

		rm -rf /var/www/$dwebsite /etc/httpd/sites-available/$dwebsite.conf /etc/httpd/sites-enabled/$dwebsite.conf
		funct_check
		funct_menu
		}
		clear
		funct_choosedwebname
	# შექმნა
	elif [[ $REPLY == 1 ]];
	then
		funct_choosewebname(){
		printf "\nჩაწერე საიტის სახელი (www-ს გარეშე): "

		read website

		if [[ $(ls /var/www/ | grep -q "$website" && echo 1 || echo 0) == 1 ]];
		then
			clear
			printf "\e[31;1mსაიტის ჩანაწერი უკვე არსებობს\e[0m"
			funct_choosewebname
		fi

		midwebsite=$(echo $website | cut -d"." -f1 )

		if [[ $(ls /var/named/$midwebsite.db &> /dev/null || echo 0) == '0' ]];
		then
			clear
			printf "\e[31;1mსაიტისთვის ვერ მოიძებნა db ფაილი\e[0m"
			funct_choosewebname
		fi

		if [[ $(cat /etc/named.conf | grep -q "$website" || echo 0) == 0 ]];
		then
			clear
			printf "\e[31;1mსაიტისთვის ვერ მოიძებნა ზონის ჩანაწერი\e[0m"
			funct_choosewebname
		fi
		}
		clear
		funct_choosewebname
	fi
}
funct_web2
sitename=$(echo $website | cut -d"." -f 1)

#Install the Apache Web Server

which httpd &> /dev/null || yum install httpd -y &> /dev/null
firewall-cmd --permanent --add-service=http &> /dev/null
firewall-cmd --permanent --add-service=https &> /dev/null
firewall-cmd --reload &> /dev/null
systemctl start httpd &> /dev/null
systemctl enable httpd &> /dev/null
systemctl status httpd &> /dev/null

#Setting Up Virtual Hosts

mkdir -p /var/www/$website/html
mkdir -p /var/www/$website/log
chmod -R 755 /var/www

funct_choose(){
	echo -e "\e[1mაირჩიე საიტის ვიზუალი\e[0m

	1. საიტის სატესტო ვერსია მარტივი წარწერით
	2. სასურველი შიგთავსის გამოყენება საიტისთვის
"
	read -s -n 1 choose

	if [[ $choose == 1 ]];
	then
		echo "<html>
<head>
<title>Welcome to $website!</title>
</head>
<body>
<h1>Success! The $website virtual host is working!</h1>
</body>
</html>" > /var/www/$website/html/index.html
	elif [[ $choose == 2 ]];
	then
		clear
		printf "ჩაწერე ფოლდერის მისამართი სადაც საიტის შიგთავსი იმყოფება: "
		read template
		if [[ $(ls $template &> /dev/null || echo 0) == '0' ]];
		then
			clear
			echo -e "\e[31;1mფოლდერი ვერ მოიძებნა!\e[0m"
			funct_choose
		elif [[ $(ls $template &> /dev/null && echo 1) == '1' ]];
		then
			clear
		fi
		cp -r $template/* /var/www/$website/html/
	else
		clear
		funct_choose
	fi
}

clear
funct_choose

if [[ $(ls /etc/httpd/{sites-available,sites-enabled} &> /dev/null && echo 1 || echo 0) == 0 ]];
then
	mkdir /etc/httpd/{sites-available,sites-enabled}
fi

if [[ $(tail -1 /etc/httpd/conf/httpd.conf) != 'IncludeOptional sites-enabled/*.conf' ]];
then
	echo 'IncludeOptional sites-enabled/*.conf' >> /etc/httpd/conf/httpd.conf
fi

echo "<VirtualHost *:80>
ServerName $website
ServerAlias www.$website
DocumentRoot /var/www/$website/html
ErrorLog /var/www/$website/log/error.log
CustomLog /var/www/$website/log/requests.log combined
</VirtualHost>" > /etc/httpd/sites-available/$website.conf

ln -s /etc/httpd/sites-available/$website.conf /etc/httpd/sites-enabled/$website.conf

systemctl restart httpd

funct_browse(){
clear
echo -e "1. lynx-ით ნახვა\n2. firefox-ით ნახვა\n3. მთავარ სიაში დაბრუნება"
read -s -n 1

if [[ $REPLY == 1 ]];
then
	clear
	which lynx &> /dev/null || yum install lynx -y
	clear
	lynx $website
	clear
	funct_browse
elif [[ $REPLY == 2 ]];
then
	clear
	which firefox &> /dev/null || yum install firefox -y
	clear
	sudo -H gnome-terminal -e "firefox $website"
	clear
	funct_browse
elif [[ $REPLY == 3 ]];
then
	clear
	funct_check
	funct_menu
else
	funct_browse
fi
}
funct_browse
}

########## PING ######## Added in 13.apr.2022 # Edited in 12.jul.2022

funct_ping(){
sitens1=$(cat /var/named/*.db | grep ns1 | sed -n "2p" | cut -d" " -f2 | awk '{print $2}')
list="$(echo -e "$sitens1 \n$(grep 'zone' /etc/named.conf | sed '1d' | sed '/\/etc\/named/d' | sed '/addr.arpa/d' | sed -s 's/"//g' | awk '{print $2}' | sed -s "/$(grep 'reverse' /etc/named.conf | awk '{print $2}' | cut -d'.' -f2)/d")")"
amount=$(echo "$list" | wc -l)
count=0

while [ $count -lt $amount ]
do
        ((count++))
        printf "$count) "
        echo "$list" | sed -n "$count p"
        slist+=$(printf "\n$count " && echo "$list" | sed -n "$count p")
done

echo -e "\n[q] Go back"
read -s -n1 choosen

if [[ $choosen -eq 'q' ]]; 
then
        slist=''
        clear
		funct_menu
fi

if [[ $(echo "$slist" | grep "^$choosen") ]]; 
then
        clear
        target="$(echo "$slist" | grep "^$choosen" | cut -d" " -f2)"
        ping -c 2 $target
        echo -e "\n[Enter] Go back"
        slist=' '
        read -s -n1 
        if [[ $REPLY == "" ]]; 
        then
                clear
                funct_ping
        else
                echo -e "\n\e[91;1mWrong input!\e[0m\n"
        fi
else
        echo -e "\e[91;1mWrong input!\e[0m"
        sleep 1
        clear
        funct_ping
fi
}

#################################################################

##################### Website Information ########################## Added in 12.Jul.2022
funct_webinfo(){
which fping || yum install fping -y || dnf install fping -y
which curl || yum install curl -y || dnf install curl -y
clear
wcount=0
webs=$(ls /var/www | sed '/cgi-bin\|html/d' | wc -l)

while [ $wcount -lt $webs ]
do
        ((wcount++))
        echo "$wcount"') '$(ls /var/www | sed '/cgi-bin\|html/d' | sed -n "$wcount p")
        wlist+=$(printf "\n$wcount " && ls /var/www | sed '/cgi-bin\|html/d' | sed -n "$wcount p")
done    

echo -e "\n[q] Go back"
read -s -n1 choosen

if [[ $choosen -eq 'q' ]];
then
        wlist=''
        clear
        funct_menu
fi      

if [[ $(echo "$wlist" | grep "^$choosen") ]];
then
        clear
        theone="$(echo "$wlist" | grep "^$choosen" | cut -d" " -f2)"
        curl -s -w 'Testing Website Response Time for :%{url_effective}\n\nLookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null "www.$theone"; printf "\n";fping "www.$theone"
        echo -e "\n[Enter] Go back"
        wlist=''
        read -s -n1
        if [[ $REPLY == "" ]];
        then
                clear
                funct_webinfo
        else
                echo -e "\n\e[91;1mWrong input!\e[0m\n"
        fi      
else
        echo -e "\e[91;1mWrong input\e[0m"
        sleep 1
        clear 
        funct_webinfo
fi
}
###################################################################################################

clear

if [[ $bindd == 0 ]]
then
	x='\e[92m9. Install bind\e[0m'
elif [[ $bindd == 1 ]];
then
	x='\e[91;1m9. Remove bind\e[0m'
fi

### მთავარი სიის ფუნქცია სადაც გვექნება არჩევანის უფლება და სია ჩვენი მონაცემების
funct_menu(){
funct_check
printf "
$y
აირჩიე

1. listen-on		6. slave site
2. allow-query		7. web
3. allow-transfer	8. ping addresses
4. ns1			$x
5. master site		\e[91m0. exit\e[0m

┌───────────────────────────────────────────────────────
│\e[1mInfo:\e[0m
├────────────────┬──────────────────────────────────────
│\e[1mIP Address:\e[0m \t │$ip
├────────────────┼──────────────────────────────────────
│\e[1mSubnet Mask:\e[0m\t │$(ifconfig | sed -n '2p' | awk '{print $4}')
├────────────────┼──────────────────────────────────────
│\e[1mDefault Gateway:│\e[0m$(route -n | sed -n '3p' | awk '{print $2}')
├────────────────┼──────────────────────────────────────
│\e[1mDNS:\e[0m \t$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | sed 's/^/\t\t │/' | sed 's/^/│/' | sed '1s/│//' | sed '1s/\t//')
├────────────────┼──────────────────────────────────────
│\e[1mSelinux:\e[0m\t │$(cat /etc/selinux/config | sed -n '/^SELINUX=/p' | cut -d"=" -f 2)
├────────────────┼──────────────────────────────────────
│\e[1mlisten-on:\e[0m\t │$listenon
├────────────────┼──────────────────────────────────────
│\e[1mallow-query:\e[0m\t │$allowquery
├────────────────┼──────────────────────────────────────
│\e[1mallow-transfer:\e[0m │$allowtransfer
├────────────────┼──────────────────────────────────────
│\e[1mNS1:\e[0m\t\t │$sitens1
├────────────────┼──────────────────────────────────────
│\e[1mZones:\e[0m$(grep 'zone "\|type ' /etc/named.conf | sed '1,2d' | awk '{print $2}' | sed 's/slave;/\\e[91;1mslave\\e[0m\\n│\\t\\t │/g' | sed 's/master;/\\e[96;1mmaster\\e[0m\\n│\\t\\t │/g' | sed 's/^/\t\t │/' | sed 's/^/│/' | sed '1s/│//' | sed '1s/\t//' | sed '1s/^/\t/')
├────────────────┼──────────────────────────────────────
│\e[1mWeb:\e[0m$(ls /var/www | sed '/cgi-bin\|html/d' | sed 's/^/\t\t │/' | sed 's/^/│/' | sed '1s/│//' | sed '1s/\t//' | sed '1s/^/\t/')
└────────────────┴──────────────────────────────────────
"

read -s -n 1

	if [[ $REPLY == 1 ]];
	then
		clear
		funct_listen-on
	elif [[ $REPLY == 2 ]];
	then
		clear
		funct_allow-query
	elif [[ $REPLY == 3 ]];
	then
		clear
		funct_allow-transfer
	elif [[ $REPLY == 4 ]];
	then
		clear
		funct_ns1
	elif [[ $REPLY == 5 ]];
	then
		clear
		funct_site
	elif [[ $REPLY == 6 ]];
	then
		clear
		funct_slave
	elif [[ $REPLY == 7 ]];
	then
		clear
		funct_web
	elif [[ $REPLY == 8 ]];
	then
		clear
		funct_ping
        elif [[ $REPLY == 9 ]];
        then
                clear
                funct_x
	elif [[ $REPLY == 0 ]];
	then
		clear
		exit
	else
		clear
		funct_menu
	fi
}

# ფუნქცია რომელიც უზრუნველყოფს ინფორმაციას ცვლადებისთვის მთავარ სიაში
funct_check(){
        if [[ $(cat /var/named/*.db | grep -q ns1 && echo 1 || echo 0) == '1' ]];
        then
                sitens1=$(cat /var/named/*.db | grep ns1 | sed -n "2p" | awk '{print $2}')
                namens1=$(cat /var/named/*.db | grep "^ns1" | awk '{print $1}' | sed 's/.$//')
                clear
        elif [[ $(cat /var/named/*.db | grep -q ns1 && echo 1 || echo 0) == '0' ]];
	then
		sitens1=""
		namens1=""
		clear
        fi

listenon=$(grep "listen-on" /etc/named.conf | sed -n '1p' | sed 's/\tlisten-on port 53 //')
allowquery=$(grep "allow-query" /etc/named.conf | sed 's/\tallow-query     //')
allowtransfer=$(grep "allow-transfer" /etc/named.conf | sed 's/\tallow-transfer\t//')
zones=$(grep 'zone "\|type ' /etc/named.conf | sed '1,2d' | awk '{print $2}' | sed 's/slave;/\\e[91;1mslave\\e[0m\\n/g' | sed 's/master;/\\e[96;1mmaster\\e\\n[0m/g' | sed 's/^/\t\t │/' | sed 's/^/│/' | sed '1s/│//' | sed '1s/\t//')
}

funct_check 2> /dev/null
funct_menu 2> /dev/null
