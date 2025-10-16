#!/bin/bash

NSTATES="${1:-10}"
FILE="${2:-orca.out}"
LINES1=$((NSTATES + 2))

grep -A $LINES1 "State   Energy  Wavelength   fosc         T2         TX        TY        TZ" $FILE |awk '{print $4}' | tail -n+3 > fosc.tmp 
grep -A $NSTATES "IROOT=  0:" $FILE | awk '{print $3}' > ee.tmp

for d in 0 $(seq $NSTATES); do 
	echo $d >> nstates.tmp
done

echo "STATE   EE(eV)     fosc" 
paste nstates.tmp ee.tmp fosc.tmp
rm nstates.tmp ee.tmp fosc.tmp
