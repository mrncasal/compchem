
for d in 0 $(seq 10); do 
	cd afast-$d 
	for f in 2* ; do
		#cp ../append.jmol $f/
		cd $f
		sed -e "3r append.jmol" nto_jmol.spt > nto_jmol.mod.spt
		java -jar /home/mrncasal/Downloads/jmol-14.29.29/Jmol.jar -n nto_jmol.mod.spt
		cd ../.
	done
cd ../.

echo $d >> progress.txt
done	


for d in $(seq 5); do
        cd aprox-$d
        for f in 2* ; do
                cp ../append.jmol $f/
                cd $f
                sed -e "3r append.jmol" nto_jmol.spt > nto_jmol.mod.spt
                java -jar /home/mrncasal/Downloads/jmol-14.29.29/Jmol.jar -n nto_jmol.mod.spt
                cd ../.
        done
cd ../.

echo $d >> progress.txt



