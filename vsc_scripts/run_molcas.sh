
#!/bin/bash

indir=`pwd`
name=`basename $indir`
error=$name.err
cluster=${6:-"wice"}
INPUT=$1
MEMORY=$2
#TIME=${3:-"24"}
PROCS=${4:-1}
ACCOUNT=${5:-"lp_computational_photochemistry-small"}

cat <<END > molcas.job
#!/bin/bash
#SBATCH --cluster=$cluster
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=$PROCS
#SBATCH --time=06-23:00:00
#SBATCH --job-name=$name
#SBATCH -o $name.stdout
#SBATCH -A $ACCOUNT
#SBATCH --mem-per-cpu=10000M
#SBATCH --partition=batch_long

# Setting up the scratch
mkdir $VSC_SCRATCH/\$SLURM_JOB_ID
cd $VSC_SCRATCH/\$SLURM_JOB_ID
cp $indir/* .

module load cluster/wice/batch
module load HDF5
module load intel/2023a

MOLCAS=/data/leuven/301/vsc30101/openmolcas/
export MOLCAS

MOLCAS_WORKDIR=/data/leuven/353/vsc35379/tccm_course/students/sme/01-conical_intersection/S1-MECP-CAS/MECP
export \$MOLCAS_WORKDIR

MOLCAS_MEM=\$SLURM_MEM_PER_CPU
export \$MOLCAS_MEM

echo \$MOLCAS >> oi
echo \$MOLCAS_MEM >> oi
echo \$MOLCAS_WORKDIR >> oi

\$MOLCAS/pymolcas $INPUT > ${INPUT%.inp}.log 

END

echo "cp * $indir/" >> molcas.job

sbatch molcas.job
#rm -f $indir/stm.job
exit 0

