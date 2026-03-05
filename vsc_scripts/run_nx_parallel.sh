#!/bin/bash

script=$1
indir=$(pwd)
#procs=$2
cluster=${2:-"wice"}
batch=${3:-"batch_sapphirerapids_long"}
dir1=$4
dir2=$5
tag=$6
name="$dir1-$dir2"

# Help
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo ""
    echo "Usage: SCRIPT PROCS [CLUSTER] [BATCH] [DIR1] [DIR2] [TAG]"
    echo "Description: Submission script for Newton-X CS on VSC."
    echo "SCRIPT: refers to which NX-CS script you want to call (e.g., nx_moldyn or nx_restart)."
    echo "Cluster: wice or genius"
    echo "Batch: batch_long, batch_icelake_long, batch_sapphirerapids_long,"
    echo "       batch, batch_icelake, batch_sapphirerapids"
    echo ""
    exit 0
fi

if [ "$cluster" != "wice" ] && [ "$cluster" != "genius" ]; then
    echo ""
    echo "Third argument should be the cluster's name: genius or wice."
    echo ""
    exit 0
fi

# Memory and time settings
if [ "$cluster" != "wice" ] && [ $cluster != "genius" ] ; then
    echo ""
    echo "Third argument should be the cluster's name: genius or wice."
    echo ""
    exit 0
fi

if [ "$batch" = "batch_long" ] || [ "$batch" = "batch_icelake_long" ] || [ "$batch" = "batch_sapphirerapids_long" ]  ; then
    time_limit="6-23:00:00"

    if   [ "$batch" = "batch_long" ] && [ $cluster = "genius" ] ; then
        mem=5000
    elif [ "$batch" = "batch_icelake_long" ] || [ "$batch" = "batch_long" ] ; then
        mem=3400
    elif [ "$batch" = "batch_sapphirerapids_long" ] ; then
        mem=2500
    fi

elif [ "$batch" = "batch" ] ||  [ "$batch" = "batch_icelake" ] || [ "$batch" = "batch_sapphirerapids" ] ; then
    time_limit="72:00:00"

    if   [ "$batch" = "batch_icelake" ] ; then
        mem=3400
    elif [ "$batch" = "batch_sapphirerapids" ] ; then
        mem=2500
    elif [ "$batch" = "batch" ] && [ $cluster = "genius" ] ; then
	mem=5000
    fi
fi

echo "Submitting job to queue $batch and cluster $cluster"      

cat <<EOJ > $name.slurm
#!/bin/bash
#SBATCH --cluster=$cluster
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=70
#SBATCH --time=$time_limit
#SBATCH --job-name=$name
#SBATCH -o $name.stdout
#SBATCH -e $name.stderr
#SBATCH --partition=$batch
#SBATCH -A lcomputational_photochemistry
#SBATCH --mem-per-cpu=${mem}M

module load cluster/$cluster/$batch
module load OpenBLAS/0.3.24-GCC-13.2.0

# Gaussian setup
export GAUSS_SCRDIR=/scratch/leuven/353/vsc35379/scratch_gaussian
export g16root=/data/leuven/301/vsc30101/g16A03
. \$g16root/bsd/g16.profile
export GAUSS_EXEDIR=\$g16root

# Newton-X setup
export NXHOME=/data/leuven/353/vsc35379/softwares/NX-NS/bin
export CIOVERLAP=/data/leuven/353/vsc35379/softwares/NX-CS/newtonx-cs/bin/cioverlap-64

# --- Parallel execution of two calculations ---
(
    cd $indir/$dir1 || exit 1
    echo "Running first calculation in $indir/$dir1"
    \$NXHOME/$script &> $script.out
) &

(
    cd $indir/$dir2 || exit 1
    echo "Running second calculation in $indir/$dir2"
    \$NXHOME/$script &> $script.out
) &

wait

# Optional: sync scratch back
#rsync -avzh --exclude "DEBUG" --exclude "TEMP" \$VSC_SCRATCH/\$SLURM_JOB_ID/* $indir/calc1/
#rsync -avzh --exclude "DEBUG" --exclude "TEMP" \$VSC_SCRATCH/\$SLURM_JOB_ID/* $indir/calc2/

exit 0
EOJ

if [[ -n "$tag" ]]; then
    sbatch -J "$name-$tag" $name.slurm
else
    sbatch $name.slurm
fi

exit 0

