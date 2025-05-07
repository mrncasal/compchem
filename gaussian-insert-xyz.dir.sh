#!/bin/bash

WORKDIR=$(pwd)
TEMPLATE='b3lyp-d3-td.template'

cd $WORKDIR


for d in 0 $(seq 10); do
	cp $TEMPLATE CALC.c1.d$d
	cd CALC.c1.d$d
	sed -e '1,2d' geom.xyz > tmp.xyz 
	sed -e "10r tmp.xyz" $TEMPLATE > gaussian.com
	cd -
done

#for d in $(seq 5); do
#        cp gaussian.template aprox-$d
#        cd aprox-$d
#        sed -e '1,2d' *.xyz > tmp.xyz
#        sed -e '8r tmp.xyz' gaussian.template > gaussian.com
#	cd -
#done	
