#!/bin/bash

x2t *xyz > coord

type="$1"

if [ "$type" = "sym" ] ; then 

	for word in " " " " "a coord" "desy" "*" "no" "b" "all def2-SV(P)" "*" "eht" "y" " " " " "scf" "iter" "300" " " "cc" "cbas" "*" "*" "dft" "on" "func bh-lyp" "*" "*" ; do
		echo "$word"
		sleep 1
	done | define

elif [ "$type" = "nosym" ] ; then
        for word in " " " " "a coord" "*" "no" "b" "all def2-SV(P)" "*" "eht" "y" " " " " "scf" "iter" "300" " " "cc" "cbas" "*" "*" "dft" "on" "func bh-lyp" "*" "*" ; do
	        echo "$word"
                sleep 1
        done | define

fi
