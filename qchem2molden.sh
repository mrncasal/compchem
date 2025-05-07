#!/bin/bash


FILE=$1
MOLDEN_FILE=${FILE%.out}.mld 

start_string="======= MOLECULAR ORBITALS IN MOLDEN FORMAT ======="
end_string="======= END OF MOLDEN-FORMATTED INPUT FILE ======="
start_line=$(grep -n "$start_string" $FILE | cut -d: -f1)
end_line=$(grep -n "$end_string" $FILE | cut -d: -f1)
total_lines=$(wc -l $FILE | awk '{print $1}')

tail_lines=$((total_lines - start_line))
head_lines=$((tail_lines - 10))

tail -n $tail_lines $FILE | head -n $((end_line - start_line - 1)) > $MOLDEN_FILE
