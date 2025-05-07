#!/bin/bash

# This script collects information about the current free nodes in dirac.
# It will show by default the first 10 available nodes in numeric order. 
# This can be expanded by giving how many nodes should be printed as an 
# argument to this script. 
#
# Author: Mariana Casal.
# 30/10/2023

N="${1:-10}"
user="${2:-`whoami`}"




if [[ $@ == 0 ]] ; then
printf "%-6s %10s %-6s %6s %8s \n" "Node" "Tot_limit" "Tot_procs" "Memory" "Scratch"

qsum -u mariana | awk -v N="$N" 'NF >=2 && $1 != "m2022" && $(NF-1) == 0 {
	
	name = $1
	tlimit = $(NF-2)


	if ($1 ~ /^[A-Za-z]+[0-9]+$/) {
		
		if (N == 0) {
			exit
		} 

		else {
	
			number = $1
		        sub(/^[A-Za-z]+/, "", number)
			command = "qc | grep -w node" number  
			while ((command | getline line) > 0) {
			
		
	                split(line, fields, " ")
	                procs   = fields[10]
	                cores   = fields[12]
			tprocs  = procs * cores
			mem     = fields[4]
			scratch = fields[6]		
	                
				if (index(tlimit, ":") == 0) {
	
				printf "%-6s %10s %9s %6s %8s  \n", name, "    --   ", tprocs,  mem, scratch
	 			}
	
				else {
				printf "%-6s %10s %9s %6s %8s \n", name, tlimit, tprocs, mem, scratch
				} 
	
			}
			close(command)
		N--
		}
	}
}'

else
printf "%-6s %10s %-6s %6s %8s \n" "Node" "Tot_limit" "Tot_procs" "Memory" "Scratch"

qsum -u mariana | awk -v N="$N" 'NF >=2 && $1 != "m2022" && $(NF-1) == 0 {
	
	name = $1
	tlimit = $(NF-2)


	if ($1 ~ /^[A-Za-z]+[0-9]+$/) {
		
		if (N == 0) {
			exit
		} 

		else {
	
			number = $1
		        sub(/^[A-Za-z]+/, "", number)
			command = "qc | grep -w node" number  
			while ((command | getline line) > 0) {
			
		
	                split(line, fields, " ")
	                procs   = fields[10]
	                cores   = fields[12]
			tprocs  = procs * cores
			mem     = fields[4]
			scratch = fields[6]		
	                
				if (index(tlimit, ":") == 0) {
	
				printf "%-6s %10s %9s %6s %8s  \n", name, "    --   ", tprocs,  mem, scratch
	 			}
	
				else {
				printf "%-6s %10s %9s %6s %8s \n", name, tlimit, tprocs, mem, scratch
				} 
	
			}
			close(command)
		N--
		}
	}
}'

fi
