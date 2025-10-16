#!/bin/bash

MOS=$1

for i in {1..$MOS}; do
 cat > plot-orbitals.spt << EOF
  background white
  load 'molden_no_ci.drt1.state1.sp'
  set perspectiveDepth OFF
  mo fill nomesh
  mo translucent 0.1
  mo $i
  rotate x -8
  x = _M.moData.mos
  num = @x[$i]["index"]
  sym = @x[$i]["symmetry"]
  occ = @x[$i]["occupancy"]
  en  = @x[$i]["energy"]
  set echo bottom center ; echo @sym
  info = "Orbital info: \n \nindex " + @num + "\noccupation " + occ + "\nsymmetry " + sym + "\n"
EOF
 java -jar /molsci/jmol-14.4.1/Jmol.jar -ionx plot-orbitals.spt
