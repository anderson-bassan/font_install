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
			cd $(tildeToHome $3)
			unzip -qq $2;;
	
	esac

}

function processFontFilesNames {
	font_files_name=$(echo "$(echo ${1:0:1} | tr [:lower:] [:upper:])$(echo ${1:1})" |  tr " " "\n")
	final_name=""
		
	for name in $font_files_name;do
		name=$(echo "$(echo ${name:0:1} | tr [:lower:] [:upper:])$(echo ${name:1})" | grep -oP "([A-Z]+[a-z0-9_]+)" | tr [:upper:] [:lower:])
		final_name+=$(echo "$(echo "$name")_")
		
	done
	
	final_name=$( echo $(echo "$(echo ${final_name:0:((${#final_name}-1))}).ttf") | tr " " "_" )
	echo $final_name
	
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
copied_font_files="$(ls $( tildeToHome "~/Fonts/$(processFolderName  "$font_name")/") | grep -P "(.ttf)")"

for font_file in $copied_font_files;do
	new_font_dir=$( tildeToHome "~/Fonts/$(processFolderName  "$font_name")/")
	old_font_name="$font_file"
	new_font_name=$(processFontFilesNames "$font_file")
	
	mv $(echo "$new_font_dir$old_font_name") $(echo "$new_font_dir$new_font_name")

done

sudo cp `echo "$new_font_dir*.ttf"` /usr/share/fonts/TTF/

##  TODO  ##
#9. clear font cache and regenerate
#10. add flags logic to the command
