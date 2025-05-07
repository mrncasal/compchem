#!/bin/bash

for file in $@ ; do 
	echo ${file%.}
	/usr/local/chem/g16A03/formchk $file
	echo ""
done	
