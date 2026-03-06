#!/bin/bash

indir=`pwd`
name=`basename $indir`
error=$name.err
cluster=${5:-"wice"}
METHOD=$1
TIME=${2:-"5"}
PROCS=${3:-36}
ACCOUNT=${4:-"lp_computational_photochemistry-small"}


if grep -Fq "cosmo" $indir/control; then
smpser="ser"
else
smpser="smp"
fi

cat <<END > stm.job
#!/bin/bash
#SBATCH --cluster=$cluster
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=$PROCS
#SBATCH --time=0$TIME:00:00
#SBATCH --job-name=$name
#SBATCH -o $name.stdout
####SBATCH --partition=batch_long
#SBATCH -A $ACCOUNT
#SBATCH --mem-per-cpu=3400M

# Loading TurboMOLE 7.8

export TURBODIR=/data/leuven/301/vsc30101/turbomole7.8
export PARNODES=\$SLURM_NTASKS_PER_NODE
export TM_PAR_FORK=yes
export PATH=\$TURBODIR/scripts:\$PATH
export PATH=\$TURBODIR/bin/x86_64-unknown-linux-gnu_smp:\$PATH
export PARA_ARCH=SMP
export TURBOMOLE_SYSNAME=x86_64-unknown-linux-gnu_smp
export PATH="\$TURBODIR/smprun_scripts:\$PATH"
source \$TURBODIR/Config_turbo_env

# Setting up the scratch
mkdir $VSC_SCRATCH/\$SLURM_JOB_ID
cd $VSC_SCRATCH/\$SLURM_JOB_ID
cp $indir/* .
END

case $METHOD in

	-h|--help) 
		echo "./run_stm.job [METHOD] [TIME:5h] [PROCS:20] [ACCOUNT:SMALL] [CLUSTER:WICE]"
		echo "method=dscf, tddft, ricc2, jobex, jobex_cc2, jobex_ex, dens"
		echo "time=5 == 5 hours "
		exit 0
		;;
	dscf) 
		echo "dscf will start >> dscf.out" >> stm.job
		echo "dscf >> dscf.out" >> stm.job
		;;
	tddft)
		echo "ridft > ridft.out" >> stm.job
		echo "escf > escf.out" >> stm.job
		;;
	ricc2) 
		echo "echo dscf will start >> dscf.out" >> stm.job
		echo "dscf > dscf.out" >> stm.job
		echo "ricc2 > ricc2.out" >> stm.job
		;;
	jobex)
		echo "dscf > dscf.out" >> stm.job
		echo "jobex -ri -level cc2 -gcart 4 -c 500 > jobex.out" >> stm.job
		;;
	jobex_cc2)
		echo "dscf > dscf.out" >> stm.job
		echo "jobex -level cc2 -gcart 4 -c 500 > jobex.out" >> stm.job
		;;
	jobex_ex) 
		echo "dscf > dscf.out" >> stm.job
		echo "jobex -ri -ex -gcart 4 -c 500 > jobex.out" >> stm.job
		;;
	dens)
		echo "ricc2 -fanal > ricc2_fanal.out" >> stm.job
		;;
esac

echo "cp * $indir/" >> stm.job

sbatch stm.job
#rm -f $indir/stm.job
exit 0
