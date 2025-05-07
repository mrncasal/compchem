#! /bin/bash

## Create raw file with the os of a excitation energy calculation on Gaussian
## First line: absolute S0 os
## Following lines: excitation os
## Input file for the scrip pes_processing.py to build the PES
## 
## syntax: bash pes_processing_input.sh output_name
## 03/03/2020

WORKDIR=$(pwd)
OUT=$1

for number in 0 $(seq 10); do

	JOBDIR=$(ls -d DISPLACEMENT/CALC.c1.d$number)

	if test -f  "$JOBDIR/$OUT" ; then
		echo "$JOBDIR"
	else
		JOBDIR=$(ls -d DISPLACEMENT/CALC.c1.d$number/*)
	fi

    grep "Excited State" $JOBDIR/$OUT | awk '{print $9}'| sed 's/f=//' >> $WORKDIR/os_$number.tmp

done

for number in $(seq 0 10); do
    touch pes_os
    paste -d " " pes_os os_$number.tmp > pes_os.tmp && mv pes_os.tmp pes_os
done

sed -i 's/^ *//g' pes_os
rm *tmp

