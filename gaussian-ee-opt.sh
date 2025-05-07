!#/bin/bash

FILE=S1
grep "Excited State" $1 | awk '{print NR, $3, $5, $9}'| paste  - - -
