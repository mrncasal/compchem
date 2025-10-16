#!/bin/bash

XYZ=$1
INP=$2

check_arguments() {
if [[ $INP != *.com ]]; then
    echo "Error: second argument should be a G16 input file. "
    exit 1
fi

if [[ $XYZ != *.xyz ]]; then
    echo "Error: first argument should be a XYZ file. "
    exit 1
fi
}

add_xyz() {
sed -i "/0, 1/ q" $INP
tail -n +3 $XYZ >> $INP
echo "" >> $INP
}

check_memkey() {
 if ! grep -q "\%mem" "$INP"; then
     sed -i "1s/^/\%mem=10GB\n/" "$INP"
 fi
}

check_chkkey() {
 if ! grep -q "%chk=${INP%.com}.chk" $INP ; then 
     sed -i  "/^%chk=/c\%chk=${INP%.com}.chk" $INP
 fi
}

check_arguments
add_xyz
check_memkey
check_chkkey

head $XYZ $INP
