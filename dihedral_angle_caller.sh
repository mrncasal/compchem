#!/bin/bash

# Executes openbabel to generate opt_geometry.xyz file with the last step of a geometry optimization
# with Gaussian and runs dihedral_angle.py 

INSTRUCTION=$1
FILE="$2"
WORKDIR=$(pwd)

case $INSTRUCTION in
	batch)
		echo "This will run openbabel and dihedral_angle.py over all *$FILE directories."
			
		for d in $(ls -d *$FILE) ; do
			pwd

			# Enters file with suffix *$FILE
			cd $d/01*
			
			
			
			# Test to see if XYZ file with the optimized geometry already exists
			if test -f "opt_geometry.xyz"; then
                        	true
                	else
                        	obabel -log gaussian.log -oxyz -Oopt_geometry.xyz
                	fi
			
		

			# Run script to calculate the dihedral angle
			dihedral=$(python3 /media/mariana/mrcasal-HD/01-Em.andamento/10-Scripts/06-outros/dihedral_angle.py) 
			echo $d "     " $dihedral >> $WORKDIR/dihedral.angle.out
			cd - 
		done
	;;

	

	local)
	# Runs openbabel and dihedral_angle.py locally.
		
		# Test to see if XYZ file with the optimized geometry already exists
		if test -f "opt_geometry.xyz"; then
		true 
	else
		obabel -log gaussian.log -oxyz -Oopt_geometry.xyz
	fi 
	
	# Run script to calculate the dihedral angle. 
	python3 /media/mariana/mrcasal-HD/01-Em.andamento/10-Scripts/06-outros/dihedral_angle.py
esac

