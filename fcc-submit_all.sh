#! /bin/bash
#
# Submit FCclasses calculations taking the directory prefix as an argument. 
# M.Casal - 03/10/2023
#

# Arguments

args="$@"

#for arg in "$@"; do 
#	args+=("$arg")
#done

# Directories

echo "FCclasses will run in:"

for dir in $args* ; do 
	echo "     " $dir 
done
echo " " 
echo "----------"
echo " " 

# FCclasses
export LC_ALL=C
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/chem/fcclasses-3.1.0/extralib
. /usr/local/chem/fcclasses-3.1.0/vars


for dir in $args* ; do 
	cd $dir 
        /usr/local/chem/fcclasses-3.1.0/bin/fcclasses3 fcc.inp
	if grep -q "FCclasses" "fcc.out" ; then
	    echo "$dir finished"
	fi
	sleep 2s
	cd - >/dev/null
done

