#! /bin/bash

for d in 0 $(seq 10) 20; do 

	echo afast-$d > afast-$d.dat
	grep "Total energy" afast-$d/detailed.out | awk '{print $5}' >> afast-$d.dat
	awk '{print $1}' afast-$d/EXC.DAT | sed '1,5d' >> afast-$d.dat

done

for d in $(seq 5) ; do

        echo aprox-$d > aprox-$d.dat
        grep "Total energy" aprox-$d/detailed.out | awk '{print $5}' >> aprox-$d.dat
        awk '{print $1}' aprox-$d/EXC.DAT | sed '1,5d' >> aprox-$d.dat

done

paste -d ";" aprox-5.dat aprox-4.dat aprox-3.dat aprox-2.dat aprox-1.dat afast-0.dat afast-1.dat afast-2.dat afast-3.dat afast-4.dat afast-5.dat afast-6.dat afast-7.dat afast-8.dat afast-9.dat afast-10.dat afast-20.dat > energies.csv

rm *dat
