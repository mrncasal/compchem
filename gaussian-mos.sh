#!/bin/bash

# Correct space between -> and <- from G16 output file when IOP is used.
# Run gaussian-mos.py for number of states $nr_states. 
# 23/05/2023

file=$1
nr_states=$2

# Functions

function check_keyword () {
keyword=False
if n=$(grep -wic "$1" $2); then
    keyword=True
fi 
}


# Is this file prepared for TheoDORE?

check_keyword "IOP" "$file"
keyword=True

if [ $keyword == True ]; then
	sed -e 's/->/-> /' -e 's/<-/ <-/' -e 's/<-/<- /' $file > $file.todelete
	keyword=False
	for state in $(seq $nr_states); do
        	python3 /home/mariana/.scripts/scripts/gaussian-mos.py $file.todelete $state
	done
	rm $file.todelete
else
	for state in $(seq $nr_states); do
        	python3 /home/mariana/.scripts/scripts/gaussian-mos.py $file $state
	done	
fi
