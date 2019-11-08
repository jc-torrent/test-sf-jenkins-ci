#!/bin/sh
git diff --name-only $1 $2 > temp.txt
grep "^test-ci\/force-app" temp.txt > files.txt
awk '{gsub(/test-ci\//,"")}1' files.txt > temp.txt && mv temp.txt files.txt
awk '{$1=$1};1' files.txt > temp.txt && mv temp.txt files.txt
head files.txt
# need to remove file names that aren't in the force-app directory
FILE_LIST="$(awk '{print}' ORS=',' files.txt | sed '$s/.$//')"
if [ $FILE_LIST ]
then
    /usr/local/bin/sfdx force:source:convert -d mdapi-out --sourcepath "force-app/main/default/classes/TestClass1.cls" --json
else
    echo "No files have changed since last successful build."
fi

