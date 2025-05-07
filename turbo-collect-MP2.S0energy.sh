#!/bin/bash


for d in *7; do 

	grep "Final MP2 energy" $d/ricc2.out | awk '{print $6}' >> state.energy_$d 
	grep "Total energy of excited state:" $d/ricc2.out | awk '{print $6}' >> state.energy_$d 
	done



