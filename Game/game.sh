#!/bin/bash

p1="0"
p2="0"

fn_def(){
player=$(printf "\e[96;1m(X) Player 1\e[0m")
t="1"
x="1"
a1=" "
a2=" "
a3=" "
a4=" "
a5=" "
a6=" "
a7=" "
a8=" "
a9=" "
}

fn_place1(){
x="1"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│\e[45;1m $a1 \e[0m│ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place2(){
x="2"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │\e[45;1m $a2 \e[0m│ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place3(){
x="3"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │\e[45;1m $a3 \e[0m│
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place4(){
x="4"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│\e[45;1m $a4 \e[0m│ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place5(){
x="5"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │\e[45;1m $a5 \e[0m│ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place6(){
x="6"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │\e[45;1m $a6 \e[0m│
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place7(){
x="7"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│\e[45;1m $a7 \e[0m│ $a8 │ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place8(){
x="8"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │\e[45;1m $a8 \e[0m│ $a9 │
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_place9(){
x="9"
printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │\e[45;1m $a9 \e[0m│
	└───┴───┴───┘
\n"
echo $player
fn_menu
}

fn_menu(){
printf "\e[1m
          Λ
        < V >    Enter

        - \e[0mRestart \e[1m
        0 \e[0mExit
"
}

fn_menu2(){
printf "\n\n\n\n\e[1m        - \e[0mRestart
\e[1m        0 \e[0mExit\n"
}

fn_up(){
	if [ $x = 1 ]; then
		clear; fn_place1; fn_key;
	fi
	if [ $x = 2 ]; then
		clear; fn_place2; fn_key;
	fi
	if [ $x = 3 ]; then
		clear; fn_place3; fn_key
	fi
	if [ $x = 4 ]; then
		clear; fn_place1; fn_key
	fi
	if [ $x = 5 ]; then
		clear; fn_place2; fn_key
	fi
	if [ $x = 6 ]; then
		clear; fn_place3; fn_key
	fi
	if [ $x = 7 ]; then
		clear; fn_place4; fn_key
	fi
	if [ $x = 8 ]; then
		clear; fn_place5; fn_key
	fi
	if [ $x = 9 ]; then
		clear; fn_place6; fn_key
	fi
}

fn_down(){
	if [ $x = 1 ]; then
		clear; fn_place4; fn_key
	fi
	if [ $x = 2 ]; then
		clear; fn_place5; fn_key
	fi
	if [ $x = 3 ]; then
		clear; fn_place6; fn_key
	fi
	if [ $x = 4 ]; then
		clear; fn_place7; fn_key
	fi
	if [ $x = 5 ]; then
		clear; fn_place8; fn_key
	fi
	if [ $x = 6 ]; then
		clear; fn_place9; fn_key
	fi
	if [ $x = 7 ]; then
		clear; fn_place7; fn_key
	fi
	if [ $x = 8 ]; then
		clear; fn_place8; fn_key
	fi
	if [ $x = 9 ]; then
		clear; fn_place9; fn_key
	fi
}

fn_right(){
	if [ $x = 1 ]; then
		clear; fn_place2; fn_key
	fi
	if [ $x = 2 ]; then
		clear; fn_place3; fn_key
	fi
	if [ $x = 3 ]; then
		clear; fn_place3; fn_key
	fi
	if [ $x = 4 ]; then
		clear; fn_place5; fn_key
	fi
	if [ $x = 5 ]; then
		clear; fn_place6; fn_key
	fi
	if [ $x = 6 ]; then
		clear; fn_place6; fn_key
	fi
	if [ $x = 7 ]; then
		clear; fn_place8; fn_key
	fi
	if [ $x = 8 ]; then
		clear; fn_place9; fn_key
	fi
	if [ $x = 9 ]; then
		clear; fn_place9; fn_key
	fi
}

fn_left(){
	if [ $x = 1 ]; then
		clear; fn_place1; fn_key
	fi
	if [ $x = 2 ]; then
		clear; fn_place1; fn_key
	fi
	if [ $x = 3 ]; then
		clear; fn_place2; fn_key
	fi
	if [ $x = 4 ]; then
		clear; fn_place4; fn_key
	fi
	if [ $x = 5 ]; then
		clear; fn_place4; fn_key
	fi
	if [ $x = 6 ]; then
		clear; fn_place5; fn_key
	fi
	if [ $x = 7 ]; then
		clear; fn_place7; fn_key
	fi
	if [ $x = 8 ]; then
		clear; fn_place7; fn_key
	fi
	if [ $x = 9 ]; then
		clear; fn_place8; fn_key
	fi
}

fn_turn(){
	if [ $t = 1 ]; then
		player=$(printf "\e[91;1m(O) Player 2\e[0m")
		t=2
	else
		player=$(printf "\e[96;1m(X) Player 1\e[0m")
		t=1
	fi
}

fn_enter(){
	if [ $t = 1 ];
	then
		if [ $x = 1 ];
		then
			if [ "$a1" = " " ];
			then
				a1="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 2 ];
		then
			if [ "$a2" = " " ];
			then
				a2="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 3 ];
		then
			if [ "$a3" = " " ];
			then
				a3="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 4 ];
		then
			if [ "$a4" = " " ];
			then
				a4="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 5 ];
		then
			if [ "$a5" = " " ];
			then
				a5="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 6 ];
		then
			if [ "$a6" = " " ];
			then
				a6="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 7 ];
		then
			if [ "$a7" = " " ];
			then
				a7="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 8 ];
		then
			if [ "$a8" = " " ];
			then
				a8="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 9 ];
		then
			if [ "$a9" = " " ];
			then
				a9="X"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		fi
	fi
	if [ $t = 2 ];
	then
		if [ $x = 1 ];
		then
			if [ "$a1" = " " ];
			then
				a1="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 2 ];
		then
			if [ "$a2" = " " ];
			then
				a2="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 3 ];
		then
			if [ "$a3" = " " ];
			then
				a3="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 4 ];
		then
			if [ "$a4" = " " ];
			then
				a4="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 5 ];
		then
			if [ "$a5" = " " ];
			then
				a5="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 6 ];
		then
			if [ "$a6" = " " ];
			then
				a6="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 7 ];
		then
			if [ "$a7" = " " ];
			then
				a7="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 8 ];
		then
			if [ "$a8" = " " ];
			then
				a8="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		elif [ $x = 9 ];
		then
			if [ "$a9" = " " ];
			then
				a9="O"
				fn_turn
				fn_place1
				fn_key
			else
				fn_place1
				fn_key
			fi
		fi
	fi
}

player1won(){
	printf "\e[96;1m(X) Player 1 won\e[0m\n"
}

player2won(){
	printf "\e[91;1m(O) Player 2 won\e[0m\n"
}

fn_check(){
#Player1
	if [ $a1 == "X" ] && [ $a2 == "X" ] && [ $a3 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ \e[96;5;1m$a1 \e[0m│ \e[96;5;1m$a2 \e[0m│\e[96;5;1m $a3\e[0m │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

	if [ $a4 == "X" ] && [ $a5 == "X" ] && [ $a6 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ \e[96;5;1m$a4 \e[0m│ \e[96;5;1m$a5 \e[0m│\e[96;5;1m $a6\e[0m │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

	if [ $a7 == "X" ] && [ $a8 == "X" ] && [ $a9 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ \e[96;5;1m$a7 \e[0m│ \e[96;5;1m$a8 \e[0m│\e[96;5;1m $a9\e[0m │
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

	if [ $a1 == "X" ] && [ $a4 == "X" ] && [ $a7 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ \e[96;5;1m$a1 \e[0m│ $a2 │ $a3 │
	├───┼───┼───┤
	│ \e[96;5;1m$a4 \e[0m│ $a5 │ $a6 │
	├───┼───┼───┤
	│ \e[96;5;1m$a7 \e[0m│ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

	if [ $a2 == "X" ] && [ $a5 == "X" ] && [ $a8 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ \e[96;5;1m$a2 \e[0m│ $a3 │
	├───┼───┼───┤
	│ $a4 │ \e[96;5;1m$a5 \e[0m│ $a6 │
	├───┼───┼───┤
	│ $a7 │ \e[96;5;1m$a8 \e[0m│ $a9 │
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

	if [ $a3 == "X" ] && [ $a6 == "X" ] && [ $a9 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ \e[96;5;1m$a3 \e[0m│
	├───┼───┼───┤
	│ $a4 │ $a5 │ \e[96;5;1m$a6 \e[0m│
	├───┼───┼───┤
	│ $a7 │ $a8 │ \e[96;5;1m$a9 \e[0m│
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

	if [ $a1 == "X" ] && [ $a5 == "X" ] && [ $a9 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ \e[96;5;1m$a1 \e[0m│ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ \e[96;5;1m$a5 \e[0m│ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ \e[96;5;1m$a9 \e[0m│
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

	if [ $a3 == "X" ] && [ $a5 == "X" ] && [ $a7 == "X" ];
	then
		clear
		p1=$(( $p1 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ \e[96;5;1m$a3 \e[0m│
	├───┼───┼───┤
	│ $a4 │ \e[96;5;1m$a5 \e[0m│ $a6 │
	├───┼───┼───┤
	│ \e[96;5;1m$a7 \e[0m│ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player1won
		fn_menu2
	fi

#Player2

	if [ $a1 == "O" ] && [ $a2 == "O" ] && [ $a3 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ \e[91;5;1m$a1 \e[0m│ \e[91;5;1m$a2 \e[0m│\e[91;5;1m $a3\e[0m │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi

	if [ $a4 == "O" ] && [ $a5 == "O" ] && [ $a6 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ \e[91;5;1m$a4 \e[0m│ \e[91;5;1m$a5 \e[0m│\e[91;5;1m $a6\e[0m │
	├───┼───┼───┤
	│ $a7 │ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi

	if [ $a7 == "O" ] && [ $a8 == "O" ] && [ $a9 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ $a5 │ $a6 │
	├───┼───┼───┤
	│ \e[91;5;1m$a7 \e[0m│ \e[91;5;1m$a8 \e[0m│\e[91;5;1m $a9\e[0m │
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi

	if [ $a1 == "O" ] && [ $a4 == "O" ] && [ $a7 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ \e[91;5;1m$a1 \e[0m│ $a2 │ $a3 │
	├───┼───┼───┤
	│ \e[91;5;1m$a4 \e[0m│ $a5 │ $a6 │
	├───┼───┼───┤
	│ \e[91;5;1m$a7 \e[0m│ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi

	if [ $a2 == "O" ] && [ $a5 == "O" ] && [ $a8 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ \e[91;5;1m$a2 \e[0m│ $a3 │
	├───┼───┼───┤
	│ $a4 │ \e[91;5;1m$a5 \e[0m│ $a6 │
	├───┼───┼───┤
	│ $a7 │ \e[91;5;1m$a8 \e[0m│ $a9 │
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi

	if [ $a3 == "O" ] && [ $a6 == "O" ] && [ $a9 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ \e[91;5;1m$a3 \e[0m│
	├───┼───┼───┤
	│ $a4 │ $a5 │ \e[91;5;1m$a6 \e[0m│
	├───┼───┼───┤
	│ $a7 │ $a8 │ \e[91;5;1m$a9 \e[0m│
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi

	if [ $a1 == "O" ] && [ $a5 == "O" ] && [ $a9 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ \e[91;5;1m$a1 \e[0m│ $a2 │ $a3 │
	├───┼───┼───┤
	│ $a4 │ \e[91;5;1m$a5 \e[0m│ $a6 │
	├───┼───┼───┤
	│ $a7 │ $a8 │ \e[91;5;1m$a9 \e[0m│
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi

	if [ $a3 == "O" ] && [ $a5 == "O" ] && [ $a7 == "O" ];
	then
		clear
		p2=$(( $p2 + 1 ))
		printf "
\e[96;1mP1\e[0m=$p1
\e[91;1mP2\e[0m=$p2
	┌───┬───┬───┐
	│ $a1 │ $a2 │ \e[91;5;1m$a3 \e[0m│
	├───┼───┼───┤
	│ $a4 │ \e[91;5;1m$a5 \e[0m│ $a6 │
	├───┼───┼───┤
	│ \e[91;5;1m$a7 \e[0m│ $a8 │ $a9 │
	└───┴───┴───┘
\n"
		player2won
		fn_menu2
	fi
}

fn_key(){
	fn_check
	char=$(printf "\u1b")
	read -rsn1 key
		if [[ $key == $char ]]; 
		then
			read -rsn2 key
			case $key in
				'[A') fn_up ;;
				'[B') fn_down ;;
				'[C') fn_right ;;
				'[D') fn_left ;;
				*) >& fn_key ;;
			esac
		fi
		if [ $key = $(Enter) ];
		then
			clear; fn_enter
		elif [ $key = "0" ];
		then
			clear; exit
		elif [ $key = "-" ];
		then
			clear
			fn_def
			fn_place1
			fn_key
		else
			fn_key
		fi
}

fn_def
clear
fn_place1
fn_key 2> /dev/null
