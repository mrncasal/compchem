#!/bin/bash

INP=$1

check_chkkey() {
 if ! grep -q "%chk=${INP%.com}.chk" $INP ; then 
     sed -i  "/^%chk=/c\%chk=${INP%.com}.chk" $INP
 fi
}

check_wb97xd() {
 if grep -qi "wb97xd" $INP && grep -qi "EmpiricalDispersion=GD3" $INP ; then
     sed -i 's/EmpiricalDispersion=GD3//' $INP
fi
}

check_pbe0() {
 if grep -q "pbe0" $INP ; then
    sed -i 's/PBE0/PBE1PBE/I' $INP
fi 
}

check_wb97xd
check_pbe0
check_chkkey
