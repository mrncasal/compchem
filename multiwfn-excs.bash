#! /bin/bash

# Gera os arquivos em plain text para o Multiwfn para cada um dos estados 

grep -A 9 "  Results for state  2.1:" oop.geom_theta12.out > s1-molpro.txt
grep -A 12 "  Results for state  3.1:" oop.geom_theta12.out > s2-molpro.txt
grep -A 12 "  Results for state  4.1:" oop.geom_theta12.out > s3-molpro.txt
grep -A 12 "  Results for state  5.1:" oop.geom_theta12.out > s4-molpro.txt
grep -A 12 "  Results for state  6.1:" oop.geom_theta12.out > s5-molpro.txt
grep -A 24 "  Results for state  7.1:" oop.geom_theta12.out > s6-molpro.txt
grep -A 18 "  Results for state  8.1:" oop.geom_theta12.out > s7-molpro.txt
grep -A 19 "  Results for state  9.1:" oop.geom_theta12.out > s8-molpro.txt
grep -A 13 "  Results for state 10.1"  oop.geom_theta12.out > s9-molpro.txt
grep -A 17 "  Results for state 11.1"  oop.geom_theta12.out > s10-molpro.txt

for d in {1..10}; do 
	grep "  Results for state" s$d-molpro.txt | awk '{print "1" " " $9}' >> s$d.txt &
	sed '1,3d' s$d-molpro.txt | awk '{print $2 " " $3 " " $4 " " $1}' >> s$d.txt &  
	sed -i 's/.1 / /g' s$d.txt &
	done
