#!/bin/bash

for d in 0 $(seq 10); do
	cp gaussian.template CALC.c1.d$d
	cd $CALC.c1.d$d
	sed -e '1,2d' *.xyz > tmp.xyz 
	sed -e "8r tmp.xyz" gaussian.template > gaussian.com
	cd -
done

#for d in $(seq 5); do
#        cp gaussian.template aprox-$d
#        cd aprox-$d
#        sed -e '1,2d' *.xyz > tmp.xyz
#        sed -e '8r tmp.xyz' gaussian.template > gaussian.com
#	cd -
#done	
