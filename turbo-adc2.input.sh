#!/bin/bash

#for d in 6 7 8 9 10 20 ; do
#        cp exc afast-$d
#        cp stm-modificado.job afast-$d
#        cd afast-$d
#        pwd >> ../progress.txt
#        x2t afast* > coord
#        for word in " " " " "a coord" "*" "no" "b" "all def2-SV(P)" "*" "eht" "y" " " " " "scf" "iter" "300" " " "cc" "freeze" "*" "cbas" "*" "memory 4000" "ricc2" "sos" "adc(2)" "maxiter 300" "*" "*" "*"; do
#                echo "$word"
#                sleep 3
#        done | define
#        cp control control1
#        sed -e "72r exc" control1 > control
#        cd -
#done

for d in 1 2 3 4 5 ; do
        cp exc aprox-$d
        cp stm-modificado.job aprox-$d
        cd aprox-$d
        pwd >> ../progress.txt
        x2t aprox* > coord
        for word in " " " " "a coord" "*" "no" "b" "all def2-SV(P)" "*" "eht" "y" " " " " "scf" "iter" "300" " " "cc" "freeze" "*" "cbas" "*" "memory 4000" "ricc2" "sos" "adc(2)" "maxiter 300" "*" "*" "*"; do
                echo "$word"
                sleep 3
        done | define
        cp control control1
        sed -e "72r exc" control1 > control
        cd -
done
#
