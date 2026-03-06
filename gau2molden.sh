#!/bin/bash
# Converts chk file into molden format.
# Author: M. Casal
# Date: Unknwown

# Help
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: filename.log "
    echo "Description: Converts .chk file into molden format using formchk and Multiwfn."
    exit 0
fi

name=${1%.*}

echo ""
echo "Converting $name into $name.molden"
echo ""

# Converts chk into fchk
/usr/local/chem/g16A03/formchk $name.chk > /dev/null

# Converts fchk with Multiwfn
cat <<END > $name.tmp
$name.fchk
100
2
4
$name.molden
END

/usr/local/chem/Multiwfn_3.3.5/bin/multiwfn < $name.tmp > /dev/null 2>&1

rm $name.tmp
