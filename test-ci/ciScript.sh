#!/bin/sh
git diff --name-only --diff-filter=d $1 $2 > temp.txt
grep "^test-ci\/force-app" temp.txt > files.txt
awk '{gsub(/test-ci\//,"")}1' files.txt > temp.txt && mv temp.txt files.txt
awk '{$1=$1};1' files.txt > temp.txt && mv temp.txt files.txt
# need to remove file names that aren't in the force-app directory
FILE_LIST="$(awk '{print}' ORS=',' files.txt | sed '$s/.$//')"
if [ $FILE_LIST ]
then
    /usr/local/bin/sfdx force:source:convert -d mdapi-out -p "$FILE_LIST" --json
else
    echo "No files have changed since last successful build."
fi

