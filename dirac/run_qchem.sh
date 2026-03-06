#!/bin/bash
#
# Submission script for QChem 5.4 in Dirac.
# 
# Author: M. Casal
# Last update: 20/10/25.  

inp="${1:-qchem.inp}"
name="${inp%.inp}"
inpdir=`pwd`
queue=$2
procs=$3

# Help
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo " "
    echo "Usage: INPUT QUEUE PROCS [[AUX_FILE]] "
    echo "Description: Submission script for QChem 5.4 on Dirac."
    echo "Required memory in MB should be specified in the input"
    echo "file with mem_total."
    echo " "
    exit 0
fi

# Check for memory specification in the input. 
if grep -iq "mem_total" "$inp"; then
    mem=$(grep -i "mem_total" "$inp" | awk '{print $2}' | head -n 1)
else
    echo "Please, specify mem_total in the input."
    exit 0
fi

# Check for m-queue.
if [[ $queue == *"m"* ]] ; then
    node=$queue
else
    node="node$(echo $queue | sed -e 's/g//' -e 's/p//' )"
fi

cat <<END > $name.job

cd $inpdir 

echo \$PBS_JOBID > jobid
echo \$(hostname) >> jobid

# QChem info
NN=(\$(cat \$PBS_NODEFILE|wc -l))
export QC=/usr/local/chem/qchem-5.4
export QCSCRATCH=/temp0/`whoami`/\$PBS_JOBID
export QCAUX=\$QC/qcaux
export PATH=\$PATH:\$QC/bin
export LD_LIBRARY_PATH=/usr/local/gcc-10.3.0/lib64:/usr/local/OpenBLAS-0.3.20/lib
. \$QC/bin/qchem.setup.sh
#. \$QC/bin/qchem.setup.sh.rel


#. \$QC/qcenv.sh
mkdir -p \$QCSCRATCH/
cp $inpdir/$inp \$QCSCRATCH/
cd \$QCSCRATCH/
\$QC/bin/qchem -nt $procs -save $inp $name.out $name.scratch 
cp -r \$QCSCRATCH/*  $inpdir


END

qsub -q $queue -l nodes=1:$node:ppn=$procs,mem="$mem"MB $name.job -N $name
