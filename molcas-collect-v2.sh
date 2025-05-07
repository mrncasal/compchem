#!/bin/bash

# Collects energies and CI coefficients of CASSCF and/or MS-CASPT2 calculations in OpenMolcas.
# Sintaxe: bash collect-molcas number_states type_calculation file
# type_calculation options: "casscf", "mscaspt2" or, if blank, it will collect information about both calculations. 

INP=$3
NR_STATES=$1
CUTOFF=0.1
CALC_TYPE=$2

if [[ $# -eq 1 ]] ; then
    echo " Sintaxe: collect-molcas number_states type_calculation file"
    exit 0
fi

function collect-casscf { 	
	echo "# CASSCF Energies:"
	echo ""
	grep -i "RASSCF root number" $INP | tail -$2 | sed -e 's/:://' -e 's/number//' -e 's/^ */ /'
	echo ""

	echo "# CASSCF CI coefficients:"
	echo ""
	awk '/printout of CI-coefficients larger than  0.05 for root  /' RS= $INP | awk -v var=$CUTOFF '$4>var'  | sed -e 's/printout of CI-coefficients larger than  0.05 for//' # -e 's/^ */ /' 
	echo ""

}

function collect-mscaspt2 {
	
	echo "# CASPT2 Energies:"
	grep -i " CASPT2 Root" $INP | sed -e 's/:://' -e 's/^ *//'
	echo ""

	## MS-CASPT2 output
	#  1st awk finds the string and reads the output until the next blank line
	#  2nd awk only shows lines with cell $7 > than cutoff

        echo "# MS-CASPT2 Energies:"
	echo ""
	grep -i "MS-CASPT2 Root" $INP | 
	sed -e 's/:://' -e 's/^ *//'
        echo ""

	echo "# MS-CASPT2 CI coefficients:"
	echo ""
	awk '/The CI coefficients for the MIXED state nr.   /' RS= $INP | 
	awk -v var=$CUTOFF '$8>var' 					| 
	sed -e 's/The CI coefficients for the //' -e 's/of.*).//' -e 's/(.*)//' -e 's/^ *//' 

	echo ""

	echo "# Reference weight:"
	echo ""
	grep "Reference weight:" $INP | sed -e 's/^ *//' -e 's/          //'
	echo ""

	echo "# Dipole transition strengths (spin-free states):"
	echo ""
	grep -i "         1    2       " $INP | head -1 | awk '{print $3}'
	grep -i "         1    3       " $INP | head -1 | awk '{print $3}'
	grep -i "         1    4       " $INP | head -1 | awk '{print $3}'
	grep -i "         1    5       " $INP | head -1 | awk '{print $3}'
	
	echo ""
	grep "Eigenvectors" $INP  -A 5 | sed -e 's/^ */ /' -e 's/Eigenvectors:/# Eigenvectors:/'
	echo ""
}

if [ "$CALC_TYPE" = "casscf" ]; then

	echo ""
	echo "You are collecting information related only to CASSCF."
	collect-casscf > molcas.dat
	echo ""

elif [ "$CALC_TYPE" = "mscaspt2" ]; then
	
	echo ""
	echo "You are colecting information related to CASPT2 and MS-CASPT2."
	collect-mscaspt2 > molcas.dat
	echo ""

elif [ "$CALC_TYPE" = "all" ]; then 
	
	echo ""
	echo "You are collrecting information related to CASSCF, CASPT2 and MS-CASPT2."
	collect-casscf > molcas.dat
	echo "" >> molcas.dat
	collect-mscaspt2 >> molcas.dat
	echo ""
fi

cat molcas.dat
	

