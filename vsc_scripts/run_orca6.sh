#!/bin/bash

# Submission script for Orca 5.0.4 in VSC.
# Cluster (wice), partition (batch_long) and number of tasks are hard-coded.
# 10/04/2024 - M. Casal


# Help
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: INPUT [[NPROCS]] [[CLUSTER]] [[partition]]"
    echo "Description: Submission script for Orca 6.0.0 in VSC."
    exit 0
fi

#echo "But then science is nothing but a series of questions that lead to more questions. - Terry Pratchett"
echo "" 
echo "Go on, prove me wrong. Destroy the fabric of the universe. See if I care. - Terry Pratchett"
echo "" 

input=$1
nprocs=${2:-24}
name=${input%.inp}
#workdir=$VSC_SCRATCH_NODE/$USER
indir=`pwd`
output=$name.out
#chk=$indir/${input}.chk
error=$name.err
cluster=${3:-"wice"}
partition=${4:-"batch"} 

# Some comments on input (from Arne):  
#   --cluster=wice  --> uses wice cluster ( wice or genius are the current Tier-2 clusters)
#   --nodes sets the amount of nodes,  for gaussian you should never take more than 1 node: we don't have the license
#   --nodes continued: to do multi-node calculations anyway (because it wasn't efficient, according to Hans)
#   --nodes continued: node availability (~10 / cluster (genius/wice)) requesting a high amount of nodes will make it harder to start
#   --ntasks-per-node   36 max on genius, 72 max on wice
#   --time  uses format  days-hours:minutes:seconds  (f.e.  2-10:15:45)
#   --partition  'batch_long' long jobs (> 3 days),  long is in principle 3-7 days
#   --partition  continued:  'bigmem' high memory (2048 GB RAM / node), 28000MB/core max (wice), (768 GB RAM/node ) (genius) 
#   --partition  continued:  'gpu' GPU nodes (per GPU request 18 cores), --gpus-per-node=3 --ntasks=54
#     also interactinve partition (wice): ' srun -n 1 -t 01:00:00 -A lcomputational_photochemistry --partition=interactive --cluster=wice --pty bash -l'
#     has 16h max walltime  (example 1h walltime),  can ask for GPU  (requires also   --ntasks-per-node=8 --gpus-per-node=1 --x11 ) 1 GPU max
#     wice tips see also https://docs.vscentrum.be/en/latest/leuven/wice_quick_start.html?highlight=wice
#   --job-name  job-name (to see in squeue)
#    -o   outputlog  (+ errors)
#    -A account to use credits from (check with 'sam-balance' )
#   --mem-per-cpu=3400M is about limit for 'thin' nodes on wice (~250 Gb/n),  use --partition bigmem for bigger jobs, there limit is 28000M (~2 Tb/n)
#   --mem-per-cpu=5000M is about limit for 'thin' nodes on genius (~180 Gb/n),  use --partition bigmem for bigger jobs, there limit is ~21000M (~750 Gb/n)
# 

cat <<EOJ >$name.slurm
#!/bin/bash
#SBATCH --cluster=$cluster
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=$nprocs
#SBATCH --time=2-23:00:00
#SBATCH --job-name=$name
#SBATCH -o $name.stdout
#SBATCH --partition=bigmem
#SBATCH -A lcomputational_photochemistry
#SBATCH --mem-per-cpu=10000M

# Loading Orca
#module load cluster/$cluster/batch
export ORCA=/data/leuven/353/vsc35379/softwares/orca_6_0_0_shared_openmpi416
export MPI=/data/leuven/353/vsc35379/softwares/openmpi-4.1.6_installation
export PATH=\$MPI/bin:\$PATH
export OMP_NUM_THREADS=\$SLURM_CPUS_PER_TASK
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:\$MPI/lib

echo "MPI path:" \$MPI > JOBINFO
echo "LIBRARY:" \$LD_LIBRARY_PATH >> JOBINFO

#cd $VSC_SCRATCH
mkdir $VSC_SCRATCH/jobs/\$SLURM_JOB_ID
cd $VSC_SCRATCH/jobs/\$SLURM_JOB_ID
cp $indir/$input .
#[ -f "$indir/${input%.inp}.xyz" && cp "$indir/${input%.com}.xyz" . ] 
cp $indir/*.xyz . 
cp $indir/*.hess .

echo \$SLURM_JOB_NODELIST > $name.nodes

\$ORCA/orca $input > $output 2> $error

rsync * $indir/
#rm -f $input

exit 0

EOJ

#  submitting the inputfile created above

sbatch $name.slurm
rm -f $input.slurm

#bash /data/leuven/353/vsc35379/scripts/check_balance.sh
exit 0
