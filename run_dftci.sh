#!/bin/bash

RUN=$1


if [ "$RUN" == 'dftci' ]; then
	echo 'Running complete dftci program.'
	nohup $DFTCI/run_dftci_1a.pl & 
	echo $! - $(date +"%H:%M") - $(pwd) >> /storage/01-Em.andamento/08-BoostCrop/04-Molecules/36-DPP/job.control.txt

elif [ "$RUN" == 'dmat' ] ; then
	echo 'Running only dmat.'
	nohup $DFTCI/dmat.pl &
        echo $! - $(date +"%H:%M") - $(pwd) >> /storage/01-Em.andamento/08-BoostCrop/04-Molecules/36-DPP/job.control.txt

elif [ "$RUN" == 'mrci' ]; then
	echo 'Running only mrci step.'
	nohup $DFTCI/mrci &
        echo $! - $(date +"%H:%M") - $(pwd) >> /storage/01-Em.andamento/08-BoostCrop/04-Molecules/36-DPP/job.control.txt

else
	echo 'Choose dftci, dmat or mrci options.'

fi
