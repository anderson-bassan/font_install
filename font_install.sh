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
	read -p "font file, folder or zip: " font_files

	isValidInput $font_files
	echo $?

fi 

##  TODO  ##
#1. replace ~ to user home dir in font_files var
#2. add logic to ask the user for the dir again if any error occours
#3. Get the font name
#4. Create a Fonts folder if not exist
#5. Create font folder inside fonts
#6. proccess font files names
#7. move font files to the recently created font folder
#8. copy font files to /usr/share/fonts/TTF
#9. clear font cache and regenerate
#10. add flags logic to the command
