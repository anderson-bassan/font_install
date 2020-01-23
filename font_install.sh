#! /bin/bash

function isValidInput {
	if [  -f "$1" ] && [ $(echo $1  | grep -P "(.ttf)") ] ;then
		echo "search by the file"
		return 0
	
	elif [  -d "$1" ] && [ "$(ls $1  | grep -P "(.ttf)")" ] ;then
		echo "valid folder"
		return 0
	
	elif [  -f "$1" ] && [ "$(echo $1  | grep -P "(.zip)")" ] && [ "$(unzip -l $1  | grep -P "(.ttf)")" ] ;then
		echo "valid zip"
		return 0
	
	else
		echo "Error: the first command argument must an existing .ttf file, a folder containing .ttf files or a zip file"
		return 1
	
	fi

}


if [ $1 ];then
	isValidInput $1
	echo $?

else
	echo "ask user for font name"

fi 
