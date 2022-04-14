#!/bin/bash

#შენი საწყის (Default) მედია ფლეიერად უნდა იყოს არჩეული Celluloid ფლეიერი Linux Mint-ში
#Recommended music file extensions are mostly mp3

read -p 'ჩაწერე მუსიკების ფოლდერის მისამართი: ' location

#if $(ls $location | cat -n | sed 's/./.  /7') = false ; then
#	echo "True"
#else
#	echo "False"
#fi

fn_default(){
	printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
	ls $location | cat -n | sed 's/./.  /7'
	printf "\n     \e[96;1mΛ მაღლა\e[0m          \e[96;1mEnter ჩართვა\e[0m                    \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1mV დაბლა\e[0m          \e[96;1m< გაჩერება/გაგრძელება\e[0m           \e[96;1m> არჩევა\e[0m\n"
}

clear
fn_default
choosen=0

fn_up(){
	clear
	printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
		if [ $choosen = 1 ];
		then
			ls $location | cat -n | sed 's/./.  /7' | sed -e "1s/^    /  > /" | sed "1s/^/\x1b[1;96m/" | sed "1s/$/\x1b[0m/"
		else
			choosen=$[ $choosen - 1 ]
			ls $location | cat -n | sed 's/./.  /7' | sed -e "$(echo $choosen)s/^    /  > /" | sed "$(echo $choosen)s/^/\x1b[1;96m/" | sed "$(echo $choosen)s/$/\x1b[0m/"
		fi

	printf "\n     \e[96;1mΛ მაღლა\e[0m          \e[96;1mEnter ჩართვა\e[0m                    \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1mV დაბლა\e[0m          \e[96;1m< გაჩერება/გაგრძელება\e[0m           \e[96;1m> არჩევა\e[0m\n"
	fn_key
}

fn_down(){
	clear
	printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
		if [ $choosen = $(ls $location | wc -l) ];
		then
			ls $location | cat -n | sed 's/./.  /7' | sed -e "$(ls $location | wc -l)s/^    /  > /" | sed "$(ls $location | wc -l)s/^/\x1b[1;96m/" | sed "$(ls $location | wc -l)s/$/\x1b[0m/"
		else
			choosen=$[ $choosen + 1 ]
			ls $location | cat -n | sed 's/./.  /7' | sed -e "$(echo $choosen)s/^    /  > /" | sed "$(echo $choosen)s/^/\x1b[1;96m/" | sed "$(echo $choosen)s/$/\x1b[0m/"
		fi
	
	printf "\n     \e[96;1mΛ მაღლა\e[0m          \e[96;1mEnter ჩართვა\e[0m                    \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1mV დაბლა\e[0m          \e[96;1m< გაჩერება/გაგრძელება\e[0m           \e[96;1m> არჩევა\e[0m\n"
	fn_key
}

fn_search(){
	clear
	printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
	ls $location | cat -n | sed 's/./.  /7'
	printf "\n                                                                  \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1m00 უკან დაბრუნება\e[0m         \e[96;1mშეიყვანე ციფრი: \e[0m"
	read

		if [ $REPLY = 0 ];
		then
			pkill -9 celluloid
			clear && exit
		elif [ $REPLY = 00 ];
		then
			clear
			printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
			ls $location | cat -n | sed 's/./.  /7'
			printf "\n     \e[96;1mΛ მაღლა\e[0m          \e[96;1mEnter ჩართვა\e[0m                    \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1mV დაბლა\e[0m          \e[96;1m< გაჩერება/გაგრძელება\e[0m           \e[96;1m> არჩევა\e[0m\n"
			fn_key
		else
			if [ $REPLY -lt $[ $(ls $location | wc -l) + 1 ] ];
			then
				pkill -9 celluloid
				clear
				printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
				ls $location | cat -n | sed 's/./.  /7' | sed -e "$(echo $REPLY)s/^    /  > /" | sed "$(echo $REPLY)s/^/\x1b[1;96m/" | sed "$(echo $REPLY)s/$/\x1b[0m/"
				find "$location" -type f -name "$(ls $location | sed -n "$REPLY p")" -exec xdg-open {} \;
				choosen=$(echo $REPLY)
					while [ $choosen -lt $(ls $location | wc -l) ];
					do
						choosen=$[ $choosen +1] && find "$location" -type f -name "$(ls $location | sed -n "$choosen p")" -exec celluloid --enqueue {} \;
					done
				printf "\n     \e[96;1mΛ მაღლა\e[0m          \e[96;1mEnter ჩართვა\e[0m      \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1mV დაბლა\e[0m          \e[96;1m> არჩევა\e[0m\n"
#				sleep 1
				choosen=$(echo $REPLY)
				clear
				fn_default
				fn_key
			else
				clear
				printf "\e[91;1mარასწორი ღილაკია\e[0m"
				fn_default
				fn_key
			fi
		fi
}

fn_enter(){
	pkill -9 celluloid
	clear
	printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
		if [ $choosen = 0 ];
		then
			choosen=1
			choosen_def=$(echo $choosen)
			ls $location | cat -n | sed 's/./.  /7' | sed -e "$(echo $choosen)s/^    /  > /" | sed "$(echo $choosen)s/^/\x1b[1;96m/" | sed "$(echo $choosen)s/$/\x1b[0m/"
			find "$location" -type f -name "$(ls $location | sed -n "$choosen p")" -exec xdg-open {} \;
				while [ $choosen -le $(ls $location | wc -l) ];
				do
					choosen=$[ $choosen +1] && find "$location" -type f -name "$(ls $location | sed -n "$choosen p")" -exec celluloid --enqueue {} \;
				done
			choosen=$(echo $choosen_def)
#			sleep 1
			clear
			printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
			ls $location | cat -n | sed 's/./.  /7'
		else
			choosen_def=$(echo $choosen)
			ls $location | cat -n | sed 's/./.  /7' | sed -e "$(echo $choosen)s/^    /  > /" | sed "$(echo $choosen)s/^/\x1b[1;96m/" | sed "$(echo $choosen)s/$/\x1b[0m/"
			find "$location" -type f -name "$(ls $location | sed -n "$choosen p")" -exec xdg-open {} \;
				while [ $choosen -le $(ls $location | wc -l) ];
				do
					choosen=$[ $choosen +1] && find "$location" -type f -name "$(ls $location | sed -n "$choosen p")" -exec celluloid --enqueue {} \;
				done
			choosen=$(echo $choosen_def)
#			sleep 1
			clear
			printf "\n\e[96;1mმუსიკების სია: \e[0m\n\n"
			ls $location | cat -n | sed 's/./.  /7'
		fi

	printf "\n     \e[96;1mΛ მაღლა\e[0m          \e[96;1mEnter ჩართვა\e[0m                    \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1mV დაბლა\e[0m          \e[96;1m< გაჩერება/გაგრძელება\e[0m           \e[96;1m> არჩევა\e[0m\n"
	fn_key	
}

fn_pauseplay(){
	if [ $(ps -aux | grep celluloid | head -1 | grep SLl &> /dev/null && echo 1 || echo 0) = 0 ];
	then
		pkill -CONT celluloid
		fn_key
	elif [ $(ps -aux | grep celluloid | head -1 | grep SLl &> /dev/null && echo 1 || echo 0) = 1 ];
	then
		pkill -STOP celluloid
		fn_key
	else
		fn_key 2> /dev/null
	fi
}

fn_wrong(){
	clear
	printf "\e[91;1mარასწორი ღილაკია\e[0m\n\e[96;1mმუსიკების სია: \e[0m\n\n"
	ls $location | cat -n | sed 's/./.  /7' #| sed -e "$(echo $choosen)s/^    /  > /" | sed "$(echo $choosen)s/^/\x1b[1;96m/" | sed "$(echo $choosen)s/$/\x1b[0m/"
	printf "\n     \e[96;1mΛ მაღლა\e[0m          \e[96;1mEnter ჩართვა\e[0m                    \e[91;1m0 გამოსვლა\e[0m\n     \e[96;1mV დაბლა\e[0m          \e[96;1m< გაჩერება/გაგრძელება\e[0m           \e[96;1m> არჩევა\e[0m\n"
	sleep 1
	clear && fn_default
	fn_key
}

fn_key(){
	char=$(printf "\u1b")
	read -rsn1 key
		if [[ $key == $char ]]; 
		then
			read -rsn2 key
			case $key in
				'[A') fn_up ;;
				'[B') fn_down ;;
				'[C') fn_search ;;
				'[D') fn_pauseplay ;;
				*) >& fn_wrong ;;
			esac
		elif [ $key = "." ];
		then
			clear && fn_default && fn_key
		elif [ $key = $(Enter) ];
		then
			fn_enter
		elif [ $key = 0 ];
		then
			pkill -9 celluloid && clear;
		else
			fn_wrong
		fi
}

fn_key 
