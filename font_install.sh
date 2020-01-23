#! /bin/bash

if [ $1 ];then
	if [  -f "$1" ] && [ $(echo $1  | grep -P "(.ttf)") ] ;then
		echo "search by the file"
	
	elif [  -d "$1" ] && [ "$(ls $1  | grep -P "(.ttf)")" ] ;then
		echo "valid folder"
	
	else
		echo "the first command argument must an existing .ttf file, a folder containing .ttf files or a zip file"
	
	fi

else
	echo "ask user for font name"

fi 
