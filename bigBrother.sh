#!/bin/bash

chmod u+x bigBrother.sh
#input from the user - the folder that we check
path=$@

# first time in this path?
# check if there is file in this path
if [ -e "$path"/bigBrotherData.text ]; then
  #save names of files and folders that exist in the giving path, folder will be with '/' at the end of the name.
	ls -F "$path" > "$path"/.bigBrotherNew.text	
#.bigBrotherNew - right now after the "prev" time
	
# find files and folder that dont exist in New but exist in Data - deleted
grep -xvFf "$path"/.bigBrotherNew.text "$path"/bigBrotherData.text > "$path"/bigBrotherDel.text	

while read line
do
	#if the last char in a line is '/' - this line means to folder, else -file.
	if [[ "'${line:0-1}'" != "'/'" ]];
	then
		echo File deleted: $line
	else 
		echo Folder deleted: "${line:0:0-1}"
fi

done<"$path"/bigBrotherDel.text

# find files and folder that dont exist in Data but exist in New - created
grep -xvFf "$path"/bigBrotherData.text "$path"/.bigBrotherNew.text > "$path"/bigBrotherAdd.text	

while read line
do
	#if the last char in a line is '/' - this line means to folder, else -file.
	if [[ "'${line:0-1}'" != "'/'" ]];
	then
		echo File created: $line
	else 
		echo Folder created: "${line:0:0-1}"
fi
done<"$path"/bigBrotherAdd.text 

#delete .bigBrotherNew
rm "$path"/.bigBrotherNew.text	

#update Data
ls -F "$path" > "$path"/bigBrotherData.text	

else
# first time in this path
echo Welcome to the Big Brother
#bigBrotherData - right now, later will be as a "prev"
touch "$path"/bigBrotherData.text
chmod 777 "$path"/bigBrotherData.text

#save names of files and folders that exist in the giving path, folder will be with '/' at the end of the name.
ls -F "$path" >> "$path"/bigBrotherData.text

fi


