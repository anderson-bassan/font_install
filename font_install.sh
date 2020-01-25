#! /bin/bash
function tildeToHome {
	if [ $(echo "$1" | grep -oP "(~)" ) ]; then
		echo "$HOME$( echo $1 | grep -oP "(/[a-zA-Z0-9_/.]+)" )"
		
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
	if [  -f "$1" ] && [ "$(echo $1  | grep -P "(.ttf)")" ] ;then
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


function getFontName {
	while [ "$confirm_font_name" != "y" ]
	do
		read -p "what's the font name? " font_name
		read -p "the font name is $font_name, is that right?[y/n] " confirm_font_name

	done
	
	echo "$font_name"

}

function folderExists {
	folder=$(tildeToHome $1)
	
	if [ -d "$folder" ];then
		return 0
	
	else
		return 1
	
	fi

}

function processFolderName {
	folderNameWords=($(echo "$1" | tr " " "\n" | tr "_" "\n" ));
	processedFolderName=""
	
	for word in ${folderNameWords[@]};
	do
		processedFolderName+="$(tr '[:lower:]' '[:upper:]' <<< ${word:0:1})${word:1}"
	
	done
	
	echo $processedFolderName

}

function createFolder {
	folderExists $1
	
	if [ "$?" == "1" ];then
		folder=$(processFolderName $(tildeToHome $1))
		mkdir $folder	
	
	fi

}

function getFontType {
	if [  -f "$1" ] && [ "$(echo $1  | grep -P "(.ttf)")" ] ;then
		echo "file"
	
	elif [  -d "$1" ] && [ "$(ls $1  | grep -P "(.ttf)")" ] ;then
		echo "folder"

	else	
		echo "zip"
		
	fi

}

function copyFontFiles {
	case $1 in
		"file")
			cp $2 $(tildeToHome $3);;
			
		"folder")
			cp $(echo "$2*.ttf") $(tildeToHome $3);;
			
		"zip")
			mv $3
			unzip $2;;
	
	esac

}

if [ $1 ];then
	isValidInput $1
	
else
	font_files=$(askUserForFontFiles)
	isValidInput $font_files
	
fi 

while [ $? -ne 0 ]
do
	read -p "try again?[y/n] " try_again
	
	if [ "$try_again" == "y" ];then
		font_files=$(askUserForFontFiles)
		isValidInput $font_files
		
	else
		break
	
	fi
		
done

font_name=$(getFontName)
createFolder "~/Fonts"
createFolder "~/Fonts/$(processFolderName   "$font_name")"
copyFontFiles $(getFontType $font_files) "$font_files" "~/Fonts/$(processFolderName  "$font_name")/"

##  TODO  ##
#6. copy/extract font files to the recently created font folder
#7. proccess font files names
#8. copy font files to /usr/share/fonts/TTF
#9. clear font cache and regenerate
#10. add flags logic to the command
