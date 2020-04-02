#! /bin/bash

## Create raw file with the energies of a excitation energy calculation on Gaussian
## First line: absolute S0 energies
## Following lines: excitation energies
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

    grep "SCF Done" $JOBDIR/$OUT      | awk '{print $5}' >  $WORKDIR/energies_$number.tmp
    grep "Excited State" $JOBDIR/$OUT | awk '{print $5}' >> $WORKDIR/energies_$number.tmp

done

for number in $(seq 0 10); do
    touch pes_energies
    paste -d " " pes_energies energies_$number.tmp > pes_energies.tmp && mv pes_energies.tmp pes_energies
done

sed -i 's/^ *//g' pes_energies
rm *tmp

