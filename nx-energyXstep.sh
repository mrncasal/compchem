#!/bin/bash

## Create a csv file step x parameter (Potential Energy (eV) or Temperature (K)
## from a NX MD output file
## Syntax: bash exstep.sh output_file parameter [potential o temperature]

FILE=$1
PARAMETER=$2

STEPS=$(grep -c "Potential Energy" $FILE)
#echo $STEPS
seq -w 0 $STEPS > number_steps.tmp


case $PARAMETER in
        potential)
                ## colect potential energies
                grep "Potential Energy" $FILE| awk '{print $5}' > pot_energies.tmp
                #echo $POTENTIAL_ENERGIES
                #paste -d ";" number_steps.tmp pot_energies.tmp > stepxpot_en.csv
                paste -d "   " number_steps.tmp pot_energies.tmp > stepxpot_en.txt
                ;;
        temperature)
                ## colect temperature
                grep "Temperature" $FILE| awk '{print $5}' > temperatures.tmp
                #paste -d ";" number_steps.tmp temperatures.tmp > stepxtemperature.csv
                paste -d "   " number_steps.tmp temperatures.tmp > stepxtemperature.txt
                ;;
        *)
                echo "Choose between potential and temperature"
esac


for TMP in "pot_energies.tmp" "number_steps.tmp" "temperatures.tmp"; do
        if test -f "$TMP"; then
                rm $TMP
        fi
done

