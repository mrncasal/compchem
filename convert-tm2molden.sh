#! /bin/bash

# In frozen core calculations in TURBOMOLE, you need to delete the lines related to the frozen core keyword
# before running tm2molden.  
# Example: 
# $freeze
# implicit core=   xx virt=   x 
#
# It will run over a two level directory tree. 

for dir in $(ls -d */); do
	
	cd $dir
	
	for job_directory in $(ls -d */) ; do
                
		cd $job_directory
		MOLDENFILE=$(ls *input)
		
		if test -f "$MOLDENFILE" ; then
			echo $dir ": molden file exists"
		
		else	
			#backup file of control
			cp control control.backup

                	sed -i '/$freeze/d' control | sed '/ implicit core=   44 virt=    0/d' control
                	for answer in "molden.theodore.input" " " " "; do
                        	echo $answer
                	done | tm2molden
		fi
         	cd ../.
        	done
        cd ../.
done
