#!/bin/bash


## Takes optimized geometry (opt_geometry.xyz), adds to a Gaussian input file and changes
## the optimization geometry input to an excitation energy input. 
## 
## FROM: opt=(maxcycles=500) TO: td=(singlets , nstates=10)
## 
## Could be run in batch mode (argument: batch + "files suffix"- which depends on a specific
## directory tree - or locally.
## Date: 12/12/2019


INSTRUCTION=$1
FILE="$2"
NOW=$(date) 


echo 	"This script will change the basis set from cc-pVTZ to aug-cc-pVTZ and delete the keywords for geometry optimization and add keywords for excitation energies calculation."


case $INSTRUCTION in 
	batch)
		echo "This is a batch script over all *$FILE directories."
		
		for d in $(ls -d *$FILE) ; do
		
		        # Enters files named *$FILE
			cd $d
			echo $d
			
			
			# Copy template for the gaussian input (gaussian.template), XYZ file 
			# with the optimized geometry (opt_geometry.xyz) and submission script 
			# (sg09-scratch.job) from a previous job in a directory called 01-OPT.S0

			if test -f "opt_geometry.xyz" ; then
                        	echo "tudo certo"
                        else
                                echo "You need a file named opt_geometry.xyz with the optimized geometry."
                                exit
			fi
			cp 01-OPT.$FILE/gaussian.template 01-OPT.$FILE/opt_geometry.xyz 01-OPT.$FILE/sg09-scratch.job 02-EE.S10/
			
			# Eliminates first two lines of optimezed geometry XYZ file	
			sed -e '1,2d' 02*/opt_geometry.xyz > 02-EE.S10/tmp.xyz

			# Adds geometry and substitutes OPT keywords by EE keywords
			sed -e '8r 02-EE.S10/tmp.xyz' 02-EE.S10/gaussian.template | sed 's/opt=(maxcycles=500)/td=(singlets , nstates=10) gfinput pop=(full, chelpg) /' > 02-EE.S10/gaussian.com

			# Deletes lines for excitated state optimization
			sed -i 's/td=(nstates=3, root=1)//' 02-EE.S10/gaussian.com

			# Changes basis set from cc-pVTZ to aug-cc-VTZ
			sed -i 's/cc-pVTZ/aug-cc-pVTZ/' 02-EE.S10/gaussian.com

			# Makes sure that the end of the input file has two blank lines
			echo "" >> 02-EE.S10/gaussian.com
			echo "" >> 02-EE.S10/gaussian.com

			# Adds a comment on the input file as control mechanism 
			echo "! File modified by insert.opt.geometry.gaussian.sh on $NOW" >> 02-EE.S10/gaussian.com
			
			cd -
		
		done

			echo ""
			echo ""
			echo ""
		;;

	local)
		echo " Script running locally. You need opt_geometry.xyz and gaussian.template files"
               

		if test -f "opt_geometry.xyz" ; then
               		echo "tudo certo" 
                else
                	echo "You need a file named opt_geometry.xyz with the optimized geometry."
                	exit	
                fi
	
                # Eliminates first two lines of optmized geometry XYZ file     
		sed -e '1,2d' opt_geometry.xyz > tmp.xyz
                
		# Adds geometry and substitutes OPT keywords by EE keywords
		sed -e '8r tmp.xyz' gaussian.template | sed 's/opt=(maxcycles=500)/td=(singlets , nstates=10) gfinput pop=(full, chelpg) /' > gaussian.com
                
                # Changes basis set from cc-pVTZ to aug-cc-VTZ
                sed -i 's/cc-pVTZ/aug-cc-pVTZ/' gaussian.com

                # Deletes lines for excitated state optimization
                sed -i 's/td=(nstates=3, root=1)//' gaussian.com

		# Makes sure that the end of the input file has two blank lines
		echo "" >> gaussian.com
                echo "" >> gaussian.com
	
                # Adds a comment on the input file as control mechanism 
                echo "! File modified by insert.opt.geometry.gaussian.sh on $NOW" >> gaussian.com
	
		;;

esac
