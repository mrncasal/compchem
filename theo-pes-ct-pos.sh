#! /bin/bash


## catch the CT, POS, oscillator strength and excitation energy of each point from TheoDORE file
## directory tree: submission dir > point dir > calculation dir

sub_directory=$(pwd)

for dir in $(ls -d */); do # list of directories as a variable

	cd $dir ;
	pwd 

	for f in $(ls -d */) ; do
		newdir=${dir::-1} # returns the string minus last character	
	 
		## CT index	
		# FNR<=2 {next} means that awk ignores first 2 lines
		echo ${newdir} > $sub_directory/${newdir}_ct.dat
		awk 'FNR<=2 {next} {print $7}' $f/tden_summ.txt >>  $sub_directory/${newdir}_ct.dat

		## POS index
                echo ${newdir} > $sub_directory/${newdir}_pos.dat
                awk 'FNR<=2 {next} {print $5}' $f/tden_summ.txt >>  $sub_directory/${newdir}_pos.dat

		## Oscillator Strength
                echo ${newdir} > $sub_directory/${newdir}_foo.dat
                awk 'FNR<=2 {next} {print $3}' $f/tden_summ.txt >>  $sub_directory/${newdir}_foo.dat

		## Ground state energies. Check if it is gaussian.log, ricc2.out or escf.out.
		
		
		if test -f $f/"ricc2.out" ; then
	                echo ${newdir} > $sub_directory/${newdir}_exc.dat
   		        grep "Final MP2 energy" $f/ricc2.out | awk '{print $6}' >> $sub_directory/${newdir}_exc.dat
	        else 
	 		if test -f $f/"gaussian.log" ; then
		                echo ${newdir} > $sub_directory/${newdir}_exc.dat
				grep  "SCF Done:  E(" $f/gaussian.log  | awk '{print $5}' >> $sub_directory/${newdir}_exc.dat
			
			else 
				if test -f $f/"escf.out" ; then
				echo ${newdir} > $sub_directory/${newdir}_exc.dat
				grep -A 3 " Ground state" $f/escf.out  | awk 'FNR<= 3 {next} {print $3}' >> $sub_directory/${newdir}_exc.dat
				fi
			fi		
		fi
		
		## Excitation energies (from TheoDORE file)
                awk 'FNR<=2 {next} {print $2}' $f/tden_summ.txt >>  $sub_directory/${newdir}_exc.dat
	done
        cd ..
done

paste -d "\t"  aprox-5_ct.dat aprox-4_ct.dat aprox-3_ct.dat aprox-2_ct.dat aprox-1_ct.dat afast-0_ct.dat afast-1_ct.dat afast-2_ct.dat afast-3_ct.dat afast-4_ct.dat afast-5_ct.dat afast-6_ct.dat afast-7_ct.dat afast-8_ct.dat afast-9_ct.dat afast-10_ct.dat afast-20_ct.dat > CT.txt

paste -d "\t" aprox-5_pos.dat aprox-4_pos.dat aprox-3_pos.dat aprox-2_pos.dat aprox-1_pos.dat afast-0_pos.dat afast-1_pos.dat afast-2_pos.dat afast-3_pos.dat afast-4_pos.dat afast-5_pos.dat afast-6_pos.dat afast-7_pos.dat afast-8_pos.dat afast-9_pos.dat afast-10_pos.dat afast-20_pos.dat > POS.txt

paste -d "\t" aprox-5_foo.dat aprox-4_foo.dat aprox-3_foo.dat aprox-2_foo.dat aprox-1_foo.dat afast-0_foo.dat afast-1_foo.dat afast-2_foo.dat afast-3_foo.dat afast-4_foo.dat afast-5_foo.dat afast-6_foo.dat afast-7_foo.dat afast-8_foo.dat afast-9_foo.dat afast-10_foo.dat afast-20_foo.dat > FOO.txt

paste -d "\t" aprox-5_exc.dat aprox-4_exc.dat aprox-3_exc.dat aprox-2_exc.dat aprox-1_exc.dat afast-0_exc.dat afast-1_exc.dat afast-2_exc.dat afast-3_exc.dat afast-4_exc.dat afast-5_exc.dat afast-6_exc.dat afast-7_exc.dat afast-8_exc.dat afast-9_exc.dat afast-10_exc.dat afast-20_exc.dat > EXC.txt


echo $sub_directory > PES_all.txt ; echo "" >> PES_all.txt ; echo "" >> PES_all.txt
echo "Excitation Energies (eV)" >>  PES_all.txt ; cat EXC.txt >>  PES_all.txt ; echo "" >>  PES_all.txt
echo "Oscillator Strength"      >>  PES_all.txt ; cat FOO.txt >>  PES_all.txt ; echo "" >>  PES_all.txt
echo "CT index" 		>>  PES_all.txt ; cat CT.txt  >>  PES_all.txt ; echo "" >>  PES_all.txt
echo "POS index" 		>>  PES_all.txt ; cat POS.txt >>  PES_all.txt ; echo "" >>  PES_all.txt

rm *dat

