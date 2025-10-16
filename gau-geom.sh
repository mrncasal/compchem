#!/bin/bash

## Get the geometry of a gaussian file using openbabel
## syntax: bash script filename
##
## 20/03/2020
##


FILE=$1
FILENAME="${FILE%.*}"

obabel -log $FILE -oxyz -O$FILENAME.xyz

echo "XYZ file $FILENAME.xyz"
