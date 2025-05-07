#!/bin/bash

x2t *xyz > coord
for word in " " " " "a coord" "*" "no" "b" "all def2-SV(P)" "*" "eht" "y" " " " " "scf" "iter" "300" " " "cc" "freeze" "*" "cbas" "*" "memory 4000" "ricc2" "sos" "adc(2)" "maxiter 300" "*" "*" "*"; do
	echo "$word"
        sleep 1
done | define

cp control control1
sed -e "62r exc" control1 > control

