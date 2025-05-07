#!/bin/bash


echo "
" > 00_resume.txt

echo "# Geometry Optimization" >> 00_resume.txt

echo "
" >> 00_resume.txt

grep "          nuclear repulsion energy  :" job.last >> 00_resume.txt
grep "convergence criteria satisfied after" job.last  >> 00_resume.txt
grep "total energy" job.last | awk '{print "SCF Energy" " : "$5}' >> 00_resume.txt
grep -A1 "    Method          :" job.last >> 00_resume.txt
grep "total wall-time :" job.last >> 00_resume.txt
tail -n 1 jobex.out >> 00_resume.txt
echo "
" >> 00_resume.txt
echo "## OPTIMIZED GEOMETRY (Turbomole Format)" >> 00_resume.txt
echo "
" >> 00_resume.txt
cat *converged-geometry.xyz >> 00_resume.txt
