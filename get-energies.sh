#! /bin/bash


# Catch the excitation energies and oscillator strength from a RICC2 file
# and prints on the terminal.

OUT=$1

if test -f "ricc2.out"; then
        echo "Excitation Energies RICC2"
        grep "Energy:" ricc2.out | awk '{print $4}'
        echo " "
        echo " Oscillator Strength RICC2"
        grep "oscillator strength (length gauge)" ricc2.out | awk '{print $6}'

else
        if test -f "$OUT" ; then
                echo "Excitation energies Gaussian"
                grep "Excited State" $OUT | awk '{print $5}'
                echo ""
                echo "Oscillator Strenght Gaussian"
                grep "Excited State" $OUT | awk '{print $9}' | sed 's/f=//'    
        fi
fi

