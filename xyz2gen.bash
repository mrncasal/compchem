#!/bin/bash
inp=$1
out=${inp/xyz/gen}
awk ' $1 ~ /C/ || $1 ~/H/ {print NR-2,$0 ; }' $inp > tmp
head -n 2 $inp > tmp2
cat tmp >> tmp2
sed -e 's/H/ 2/g' -e 's/C/ 1/g' -e "1s/$/ C/" -e "2s/.*/C H/" tmp2 > $out
