#!/usr/bin/env python3
#
# Author: M. Casal
# 07/05/2025

import sys
import os


if "-h" in sys.argv or "--help" in sys.argv or len(sys.argv) < 5:
    print("""

Usage: python script.py <input_xyz> <qm_size> <template_file> <output_file>

Description:
  This script processes a molecular geometry in XYZ format, extracts a specified number of atoms as the QM region, and treats the remaining atoms as MM atoms (typically water molecules). It formats the QM atoms with multiplicity flags and appends MM atoms as point charges, using predefined charges for O and H atoms.

Arguments:
  <input_xyz>       Path to the XYZ file containing molecular geometry.
  <template_file>   Input template file that will be used as the header of the output.
  <output_file>     Name of the output file to be generated.
  <qm_size>         Number of atoms to include in the QM region.

Details:
  - The script skips the first line of the XYZ file (atom count).
  - Atoms from line 2 up to line 2 + <qm_size> are treated as QM atoms.
  - All remaining atoms are assumed to be MM atoms (only O and H are supported).
  - MM atoms are appended with partial charges (-0.8340 for O, -0.4170 for H) and a trailing zero.
  - QM atoms are written in a format: "<atom>    x   1    y   1    z   1".
  - MM atoms are written as: "   x        y        z   charge    0".

Example:
  python script.py geom_0.xyz template_cisd_abs.inp output.inp 20

Note:
  Only O and H atoms are supported for MM point charges. Other atom types will raise an error.

Help:
  -h, --help        Show this help message and exit.
""")
    sys.exit()
    

def extract_data(filename, qm_size):
    
    qm_coords = []
    mm_coords = []
    with open(filename, 'r') as f:
        next(f)
        count = 0
        for line in f:
            parts = line.strip().split()
            if len(parts) >= 5 and parts[1].isalpha():
                atom = parts[1][0]
                x = parts[2]
                y = parts[3]
                z = parts[4]
                count += 1
                if count <= qm_size:
                    qm_coords.append((atom, x, y, z))
                if count >= qm_size+1:
                    mm_coords.append((atom, x, y, z))

    return qm_coords, mm_coords    

def point_charges(mm_coords):
    
    charges = {
        'O': -0.8340,
        'H': -0.4170
    }
    
    pc_coords = []
    for atom, x, y, z in mm_coords:
        if atom in charges:
            charge = charges[atom]
            pc_coords.append((x,y,z,charge, 0))
        else:
            raise ValueError(f"Unexpected atom type: {atom}")
        
    return pc_coords      

def gen_out(template_file, output_file, qm_coords, mm_coords): 
    with open(template_file, 'r') as t:
        template_lines = t.readlines()

    with open(output_file, 'w') as out:
        out.writelines(template_lines)
        for atom, x, y, z in qm_coords:
            out.write(f"{atom:<2}  {x:>12}  {1:<9}{y:>12}  {1:<9}{z:>12}  {1}\n")
        for x, y, z, charge, zero in mm_coords:
            out.write(f"{float(x):>12.4f}{float(y):>12.4f}{float(z):>12.4f}{charge:>8.4f}  {zero}\n")
            
filename=sys.argv[1]
qm_size = int(sys.argv[2])
template_file=sys.argv[3]
output = sys.argv[4]
qm, mm = extract_data(filename, qm_size=qm_size)
pc_coords = point_charges(mm)
gen_out(template_file, output, qm, pc_coords)

# %%


# %%


# %%



