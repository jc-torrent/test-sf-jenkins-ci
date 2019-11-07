#!/bin/sh
git diff --name-only $1 $2 > files.txt
grep "^test-ci\/force-app" files.txt > files.txt
# need to remove file names that aren't in the force-app directory
FILE_LIST=$(awk '{print}' ORS=', ' files.txt | sed '$s/..$//')
echo $FILE_LIST
/usr/local/bin/sfdx force:source:convert -d mdapi-out -p "$FILE_LIST"
