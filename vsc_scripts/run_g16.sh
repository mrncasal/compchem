#!/bin/bash

input=$1
name=${input%.com}
output=$name.log
error=$name.err
indir=`pwd`
procs=$2
cluster=${3:-"wice"}
batch=${4:-"batch_sapphirerapids_long"}
account=${5:-"lcomputational_photochemistry"} 

if [ "$input" = "-h" ]; then
    echo ""
    echo "Usage: script INPUT PROCS [CLUSTER] [BATCH] [ACCOUNT] "
    echo "cluster = wice (default) or genius"
    echo "batch   = batch_long, batch_icelake_long, batch_sapphirerapids_long (default)"
    echo "          batch, batch_icelake, batch_sapphirerapids"
    echo "account = lcomputational_photochemistry (default) or lp_computational_photochemistry-small"
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

# Editing .com file
grep -q "%nprocs" $input || sed -i "1i%nprocs=$procs" $input

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
#SBATCH -A $account 
#SBATCH --mem-per-cpu=${mem}M

module load cluster/$cluster/$batch
module load Perl/5.38.0-GCCcore-13.2.0

export g16root=/data/leuven/301/vsc30101/g16A03
. \$g16root/bsd/g16.profile

mkdir -p \$VSC_SCRATCH/\$SLURM_JOB_ID
cd \$VSC_SCRATCH/\$SLURM_JOB_ID
cp $indir/$input .

g16 < $input > $indir/$output 2> $error

rsync  $name*  $indir/
rm $input.slurm $input.stderr $input.stdout

exit 0

EOJ

sbatch $name.slurm
exit 0


