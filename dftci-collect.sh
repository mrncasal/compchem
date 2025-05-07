#!/bin/bash

# Collect excitation energies (eV), %D and two most revelant configurations
# from mrci.sum of a DFT/MRCI calculation
# 04/05/2020
#

echo "EE" 
grep DFTCI mrci.sum | awk '{print $6}'
echo "" 
echo "" 

echo "%D" 
grep "% D" mrci.sum | awk '{print $6}' 
echo "" 
echo "" 

echo "oscillator str"
grep "osc.str. (L)" output.prp | awk '{print $3}'
echo ""
echo ""

echo "configurations" 
grep -A 6 DFTCI mrci.sum | sed '/^$/d' | sed '/^$/d'| sed 's/  R  //g'
echo ""
echo ""

