#!/bin/bash

name=${1%.log}
/usr/local/chem/g16A03/formchk $name.chk > /dev/null

cat <<END > $name.tmp
$name.fchk
100
2
4
$name.molden
END

/usr/local/chem/Multiwfn_3.3.5/bin/multiwfn < $name.tmp > /dev/null 2>&1
