import os

def my_function():
	os.system("clear")
	print('[1] update\n[2] upgrade\n[3] fix packages\n[4] autoremove\n\n[0] exit')
	prompt=input()
	if prompt == '1':
		os.system("clear && sudo apt update")
		my_function2()
	elif prompt == '2':
		os.system("clear && sudo apt upgrade")
		my_function2()
	elif prompt == '3':
		os.system("clear && sudo apt install -f")
		my_function2()
	elif prompt == '4':
		os.system("clear && sudo apt autoremove")
		my_function2()
	elif prompt == '0':
		os.system("clear")
	else:
		my_function()

def my_function2():
	print('\n[Enter] return\n    [0] exit\n')
	prompt2=input()
	if prompt2 == "":
		my_function()
	elif prompt2 == '0':
		os.system("clear")
	else:
		my_function2()

my_function()

