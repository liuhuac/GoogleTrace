#!/bin/bash
INPUT=schema.csv
OLDIFS=$IFS
IFS=,
pretable=null
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read filepattern filenumber content format mandatory
do
	if [ $filepattern = "file pattern" ]; then
		continue
	fi
	POS=`echo $filepattern | grep -aob '/' | grep -oE '[0-9]+'`
	table=${filepattern:0:$POS}
	if [ $mandatory = "YES" ]; then
		null="not null"
	else
		null=""
	fi
	if [ $pretable = $table ]; then
		if [ $isfirstline = true ]; then
			printf "\n"
			isfirstline=false
		else
			printf ",\n"
		fi
		printf "${content// /_} $format $null"
	else
		printf "\n);\n\n"
		printf "CREATE TABLE $table ("
		pretable=$table
		isfirstline=true
	fi
done < $INPUT
printf "\n);\n\n"
IFS=$OLDIFS
