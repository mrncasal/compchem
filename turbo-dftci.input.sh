#!/bin/bash

dir_name="$1"
no_dir="$2"

dir_atual=$(pwd)
echo $dir_atual

for d in $(seq 0 $no_dir) ; do
	cd $dir_name$d	
	cp /home/mcasal/00-SCRIPTS/submission-scripts/stm-modificado.job .
 	
	pwd >> ../progress.txt
        x2t *xyz > coord

        for word in " " " " "a coord" "desy" "*" "no" "b" "all def2-SV(P)" "*" "eht" "y" " " " " "scf" "iter" "300" " " "cc" "cbas" "*" "*" "dft" "on" "func bh-lyp" "*" "*" ; do
                echo "$word"
                sleep 1
        done | define
        cd -
done
#
