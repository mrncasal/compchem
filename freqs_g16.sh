#!/bin/bash

log=$1

for file in $@; do
	echo $file
	grep Frequencies $file | head -n 2
	echo ""
done

