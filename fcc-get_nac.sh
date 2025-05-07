file=$1
upper=$2 
natoms=$3 

# Q-Chem starts counting the states from 0 in TDDFT. 
# S0 = 0 ; S1 = 1; ...

lines=$((natoms * 3 + 21)) 

lower=$((upper - 1))

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "fcc-get_nac.sh FILE ADIABATIC_UPPER_STATE NATOMS"
    echo "Ex. NAC between states S4 and S3"
    echo "ADIABATIC_UPPER_STATE = 4"
    exit 1
fi

if [ "$#" -ge 3 ] ; then 
    echo "File: $file"
    echo ""
    echo "You are collecting the NAC between S$upper and S$lower."
    echo "In QChem syntax: $upper -> $lower"
    echo ""
    echo "NAC is written to $file. Attention: filename uses adiabatic ordering of the states."
else 
    echo "Oh-oh You are missing arguments. Please, indicate FILE UPPER_STATE and NATOMS"
    exit
fi 

out=${file%-nac.out}-$upper$lower.nac

if grep -q "between states $lower and $upper"  $file; then
	grep  "between states $lower and $upper" $file  -A $lines | tail -n $natoms | awk '{print $2 "  " $3 "  " $4}' > $out
else
	echo "NAC between root $lower and $upper not found."
	exit 1
fi

# Output message:


#echo "Adiabatic lowerstate: " $adiab_lowerstate
#echo "Adiabatic upperstate: " $adiab_upperstate
#echo ""
#echo "Lower root: " $lower_root 
#echo "Upper root: " $upper_root
