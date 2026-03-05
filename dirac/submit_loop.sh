!#/bin/bash

# Submits jobs automatically to the queue within the 30
# jobs limits of Dirac. 
#
# Not tested.  
# 

if [ "$#" -lt 1 ]; then:q

    echo "Usage: "
    exit 1
fi

INP=$1
NODE=$2
parent_dir=$(pwd)

# Reads the file with the paths to all calculations you want to run 
command eval 'CALCS=($(cat $INP))'

# Number of calculations to be run
NCALCS= ${#CALCS[@]}

# Bash start numbering lists on zero. 
COUNTER=0

# While you haven't submitted all calculations... 
while [ $COUNTER -lt $((NCALCS - 1)) ] ; do

    # Check number of current jobs... 
    N_CURRENT_JOBS=$(qstat | grep `whoami` | wc -l)    

    # if within the allowed limit...
    if $N_CURRENT_JOBS -lt 30; then

        # go to the dir of that calculation...
        cd ${CALCS[$COUNTER]}

        # do whatever you need to do...
        QSUB COMMAND BLABLA

        # come back to the directory you were in the beginning...
        # now, thinking, you don't need this part if you are giving the
        # full path in the input file.
        cd $parent_dir

        # add a number to the counter and go the next element of your
        # calculations list
        ((COUNTER++))
    else 
        # if are in your 30 jobs limit, this script will sleep for 
        # a certain amount of time. You could even put more time
        sleep 60s
    fi
done
