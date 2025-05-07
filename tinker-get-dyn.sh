#!/bin/bash
# This script plots the total, potential and kinetic energies (eV or kcal/mol) and temperature (K) from a Tinker output file. 
# UNIT: ev or kcalmol
# TYPE: plots or subplots
#
# Author: M. Casal 08/02/2023

TIMEUNIT=ps
TIMESTEP=0.1
UNIT=ev
TYPE=subplots
DYNFILE=data.dyn 

if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: echo tinker-get-dyn -f FILE -u UNIT -t plots/subplots -d DYNFILE -s TIMESTEP -w TIMEUNIT" 
    echo "Description: Plots total, potential, and kinetic energies \(ev or kcal/mol\) and temperature \(K\) from a Tinker output file."
    exit 0
fi

while getopts ":-f:-t:-u:-d:-s:-w:-h" opt ; do 
    case $opt in 
        f) FILE="$OPTARG"
        ;;
        t) TYPE="$OPTARG"
        ;;
        u) UNIT="$OPTARG"
        ;;
        d) DYNFILE="$OPTARG"
        ;;
        s) TIMESTEP="$OPTARG"
        ;;
        w) TIMEUNIT="$OPTARG"
        ;; 
        h) echo "tinker-get-dyn -f FILE -u UNIT -t plots/subplots -d DYNFILE -s TIMESTEP -w TIMEUNIT" ; exit 0
        ;;
    esac
done

export DYNFILE
export UNIT
export TYPE
export TIMEUNIT
export TIMESTEP

# if [[ $FILE == '-h' ]] ; then
#     echo "tinker-get-dyn FILE [UNIT] [TYPE]"
#     echo ""
#     echo "This script plots the total, potential and kinetic energies and temperature from a Tinker output."
#     echo "UNIT: ev (default) or kcalmol"
#     echo "TYPE: individual plots (default) or subplots"
#     exit 0
# fi

# breaking down the regular expression
# ^\s* -> starts with optional whitespace character
# [0-9]+ -> matches one or more digits 
# \s+ -> white space in between columns

if [ -n "$FILE" ]; then
    grep '^\s*[0-9]\s*[0-9]\s*[0-9]\s*[0-9]\s*[0-9]' $FILE > data.dyn
fi

python3 <<EOF

import matplotlib.pyplot as plt
import os
from matplotlib.backends.backend_tkagg import NavigationToolbar2Tk

kcalmol2ev = 0.0433641153087705
unit = os.environ.get('UNIT')
plot_type = os.environ.get('TYPE')
dynfile  = os.environ.get('DYNFILE')
timestep = float(os.environ.get('TIMESTEP'))
timeunit = os.environ.get('TIMEUNIT') 

timefs  = []
vEtotal = []
vEpot   = []
vEkin   = []
vTemp   = []

if dynfile == 'data.dyn': 
    with open('data.dyn', 'r') as file:
        for line in file:
            columns = line.strip().split()
            time  = float(columns[0])*timestep
    	
            if unit == 'ev': 
                Etotal  = float(columns[1])*kcalmol2ev
                Epot    = float(columns[2])*kcalmol2ev
                Ekin    = float(columns[3])*kcalmol2ev
            elif unit == 'kcalmol': 
                Etotal  = float(columns[1])
                Epot    = float(columns[2])
                Ekin    = float(columns[3])
    
            Temp = float(columns[4])
     
            timefs.append(time)
            vEtotal.append(Etotal)
            vEpot.append(Epot)
            vEkin.append(Ekin)
            vTemp.append(Temp)

if unit == 'ev': 
    unit_label = ' (eV)'
elif unit == 'kcalmol': 
    unit_label = ' \n(kcal/mol)'

if timeunit == 'fs': 
    timeunit_label = 'fs'
elif timeunit == 'ps': 
    timeunit_label = 'ps'
    timefs = [x / 1000 for x in timefs] 

if plot_type == 'subplots': 
    plt.subplot(4, 1, 1)
    plt.scatter(timefs, vEtotal, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Total Energy")
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Tot Energy'+unit_label)
    plt.grid(True)
    
    plt.subplot(4, 1, 2)
    plt.scatter(timefs, vEpot, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title('Potential Energy')
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Pot Energy'+unit_label)
    plt.grid(True)
    
    plt.subplot(4, 1, 3)
    plt.scatter(timefs, vEkin, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Kinetic Energy")
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Kin Energy'+unit_label)
    plt.grid(True)
    
    plt.subplot(4,1, 4)
    plt.scatter(timefs, vTemp, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Temperature")
    plt.ylim( bottom=250, top=350)
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Temperature (K) ')

    plt.grid(True)
    plt.subplots_adjust(wspace=0.7, hspace=0.7)
    plt.show()

elif plot_type == 'plots': 
    plt.figure()
    plt.scatter(timefs, vEtotal, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Total Energy"+unit_label)
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Total Energy'+unit_label)
    plt.grid(True)
    
    plt.figure()
    plt.scatter(timefs, vEpot, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Potential Energy"+unit_label)
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Potential Energy'+unit_label)
    plt.grid(True)
    
    plt.figure()
    plt.scatter(timefs, vEkin, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Kinetic Energy"+unit_label)
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Kinetic Energy'+unit_label)
    plt.grid(True)
    
    plt.figure()
    plt.scatter(timefs, vTemp, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Temperature (K)")
    plt.xlabel('Time / '+ timeunit)
    plt.ylabel('Temperature / K ')

    plt.grid(True)
    plt.subplots_adjust(wspace=0.5, hspace=0.5)
    plt.show()


EOF

	   
