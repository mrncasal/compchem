#! /bin/bash


# It copies the TheoDORE input file (dens_ana.in) from the submission directory 
# and runs TheoDORE (analyze_tden.py) for each folder. 
# Directory tree: submission directory > point directory > calculation directory

sub_directory=$(pwd)

for dir in $(ls -d */); do # list of directories as a variable
	
	# Enters the first level
	cd $dir

	for job_dir in $(ls -d */) ; do

		# Enters the second level
		cd $job_dir
		cp $sub_directory/dens_ana.in .
		analyze_tden.py

		cd ../.
	done
	cd ../.
done
