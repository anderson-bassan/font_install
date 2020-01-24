#! /bin/bash
function tildeToHome {
	if [ $(echo "$1" | grep -oP "(~)" ) ]; then
		echo "$HOME$( echo $1 | grep -oP "(/[a-zA-Z0-9/]+)" )"
		
	else
		echo $1
		
	fi

}

function askUserForFontFiles {
	read -p "font file, folder or zip: " font_files

	font_files=$(tildeToHome $font_files)
	echo $font_files

}


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
	
else
	font_files=$(askUserForFontFiles)
	isValidInput $font_files
	
fi 

echo $?

##  TODO  ##
#2. add logic to ask the user for the dir again if any error occours
#3. Get the font name
#4. Create a Fonts folder if not exist
#5. Create font folder inside fonts
#6. proccess font files names
#7. move font files to the recently created font folder
#8. copy font files to /usr/share/fonts/TTF
#9. clear font cache and regenerate
#10. add flags logic to the command
