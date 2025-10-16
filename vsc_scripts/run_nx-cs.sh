#!/bin/bash

script=$1
indir=`pwd`
name=`basename $indir`
procs=$2
cluster=${3:-"wice"}
batch=${4:-"batch_sapphirerapids_long"}

#
# Making an input-file for submitting NX-CS with G16
#
# Help
 if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo ""
    echo "Usage: SCRIPT PROCS [CLUSTER] [BATCH]"
    echo "Description: Submission script for Newton-X CS on VSC."
    echo "SCRIPT:refers to which NX-CS' script you want to call. Ex.: initcond or moldyn."
    echo "Cluster: wice or genius "
    echo "Batch: batch_long, batch_icelake_long, batch_sapphirerapids_long,"
    echo "       batch, batch_icelake, batch_sapphirerapids"
    echo ""
    exit 0
 fi

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

cat <<EOJ >$name.slurm
#!/bin/bash
#SBATCH --cluster=$cluster
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=$procs
#SBATCH --time=$time_limit
#SBATCH --job-name=$name
#SBATCH -o $name.stdout
#SBATCH -e $name.stderr
#SBATCH --partition=$batch
#SBATCH -A lcomputational_photochemistry
#SBATCH --mem-per-cpu=${mem}M

module load cluster/$cluster/$batch
module load Perl/5.38.0-GCCcore-13.2.0

mkdir -p \$VSC_SCRATCH/\$SLURM_JOB_ID
cd \$VSC_SCRATCH/\$SLURM_JOB_ID
cp -r $indir/*  .

# Set up G16 environment
export GAUSS_SCRDIR=/scratch/leuven/353/vsc35379/scratch_gaussian
export g16root=/data/leuven/301/vsc30101/g16A03
. \$g16root/bsd/g16.profile

# Set up Newton-X CS
export PERL5LIB=/user/leuven/353/vsc35379/perl-5.18/lib/5.18.0
export NX=/data/leuven/353/vsc35379/softwares/NX-CS/newtonx-cs/bin
export PATH=\$PATH:\$NX
export PATH=/data/leuven/353/vsc35379/softwares/NX-CS/newtonx-cs/source:\$PATH

# Setup scratch directory
\$NX/$script.pl > $indir/$script.out 


# Clean up
rsync -avzh --exclude "DEBUG"  \$VSC_SCRATCH/\$SLURM_JOB_ID/*  $indir/

exit 0

EOJ

sbatch $name.slurm
#rm $name.slurm

exit 0


