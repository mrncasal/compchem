# %%
"""
This script analyzes molecular simulation data by providing two core functionalities:
1. **Distance Tracking**: Computes and plots the distance between two specified atoms
   across a series of geometries stored in a TINKER-style XYZ file. This is useful for 
   monitoring structural changes or reaction coordinates over time.

2. **Energy & Temperature Plotting**: Reads a TINKER `data.dyn` file and plots the total, 
   potential, and kinetic energies, as well as temperature over time. Useful for evaluating 
   simulation stability or energy conservation.

------------------------
Usage:
    python script.py --distance <xyz_file> <n_atoms> <atom1_idx> <atom2_idx>

        <xyz_file>: Path to the XYZ file with multiple geometries.
        <n_atoms>: Number of atoms in each geometry.
        <atom1_idx>, <atom2_idx>: 1-based indices of the atoms whose distance will be computed.
        
    python script.py --dihedral <xyz_file> <n_atoms> <atom1_idx> <atom2_idx> <atom3_idx> <atom4_idx>

    <xyz_file>   : Path to the TINKER-style XYZ file with multiple geometries
    <n_atoms>    : Number of atoms in each geometry
    <atom1_idx>  : Index (1-based) of the first atom
    <atom2_idx>  : Index (1-based) of the second atom
    <atom3_idx>  : Index (1-based) of the third atom
    <atom4_idx>  : Index (1-based) of the fourth atom

    python script.py --energy <dynfile> <plot_type> <unit> <timestep> <timeunit>

        <dynfile>: Path to the TINKER dynamics file (e.g., data.dyn).
        <plot_type>: 'subplots' or 'plots' (multiple separate plots).
        <unit>: 'ev' or 'kcalmol' (units of energy).
        <timestep>: Time step used in the simulation (in fs).
        <timeunit>: 'fs' or 'ps' (unit for x-axis time).

------------------------
Requirements:
    - Python 3
    - matplotlib
    - numpy
"""

# %%
import matplotlib.pyplot as plt
import os
import sys
import math
import re
import numpy as np

# %%
# Functions for --energy
def get_ene(source_file, dynfile="data.dyn"):
    '''Gets the energies and temperature from a TINKER output file.'''
    
    print(f"Reading from: {source_file}")
    if not os.path.exists(dynfile):
        print(f"{dynfile} not found. Extracting from {source_file}...")
        pattern = re.compile(r'^\s*\d+\s+[-\d\.]+\s+[-\d\.]+\s+[-\d\.]+\s+[-\d\.]+')
        with open(source_file, 'r') as infile, open(dynfile, 'w') as outfile:
            for line in infile:
                if pattern.match(line):
                    print(line)
                    outfile.write(line)
    else:
        print(f"{dynfile} already exists. Skipping extraction.")

def read_energies(timestep, unit, dynfile="data.dyn"):
    ''' Read energies of data.dyn'''  
    
    kcalmol2ev = 0.0433641153087705    
        
    timefs  = []
    vEtotal = []
    vEpot   = []
    vEkin   = []
    vTemp   = []
    
    with open(dynfile, 'r') as file:
        for line in file:
            columns = line.strip().split()
            time  = float(columns[0])*timestep
    
            if unit == 'ev': 
                Etotal  = float(columns[1])*kcalmol2ev
                Epot    = float(columns[2])*kcalmol2ev
                Ekin    = float(columns[3])*kcalmol2ev
            elif unit == 'kcalmol': 
                Etotal  = float(columns[1])
                Epot    = float(columns[2])
                Ekin    = float(columns[3])
    
            Temp = float(columns[4])
            
            timefs.append(time)
            vEtotal.append(Etotal)
            vEpot.append(Epot)
            vEkin.append(Ekin)
            vTemp.append(Temp)
            
    return timefs, vEtotal, vEpot, vEkin, vTemp
            
def energy(source_file, dynfile='data.dyn'): 
    '''Plot energies and temperature '''
    
    get_ene(source_file)
    timefs, vEtotal, vEpot, vEkin, vTemp = read_energies(timestep, unit, dynfile)
    
    if unit == 'ev': 
        unit_label = ' (eV)'

    elif unit == 'kcalmol': 
        unit_label = ' \n(kcal/mol)'

    if timeunit == 'fs': 
        timeunit_label = 'fs'
    elif timeunit == 'ps': 
        timeunit_label = 'ps'
        timefs = [x / 1000 for x in timefs] 

    if plot_type == 'subplots': 
        plots_together(timefs, vEtotal, vEpot, vEkin, vTemp, unit_label, timeunit_label)
    elif plot_type == 'plots': 
        plots_sep(timefs, vEtotal, vEpot, vEkin, vTemp, unit_label, timeunit_label)

def plots_together(timefs, vEtotal, vEpot, vEkin, vTemp, unit_label, timeunit_label):
    plt.subplot(4, 1, 1)
    plt.scatter(timefs, vEtotal, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Total Energy")
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Tot Energy'+unit_label)
    plt.grid(True)
    
    plt.subplot(4, 1, 2)
    plt.scatter(timefs, vEpot, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title('Potential Energy')
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Pot Energy'+unit_label)
    plt.grid(True)
    
    plt.subplot(4, 1, 3)
    plt.scatter(timefs, vEkin, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Kinetic Energy")
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Kin Energy'+unit_label)
    plt.grid(True)
    
    plt.subplot(4,1, 4)
    plt.scatter(timefs, vTemp, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Temperature")
    plt.ylim( bottom=250, top=350)
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Temperature (K) ')

    plt.grid(True)
    plt.subplots_adjust(wspace=0.7, hspace=0.7)

    plt.savefig("plots_energy_temp.png", dpi=300)

def plots_sep(timefs, vEtotal, vEpot, vEkin, vTemp, unit_label, timeunit_label):

    plt.grid(True)
    plt.subplots_adjust(wspace=0.5, hspace=0.5)
    
    plt.figure()
    plt.scatter(timefs, vEtotal, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Total Energy"+unit_label)
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Total Energy'+unit_label)
    plt.grid(True)
    plt.savefig("plots_total-energy.png", dpi=300)
    
    plt.figure()
    plt.scatter(timefs, vEpot, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Potential Energy"+unit_label)
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Potential Energy'+unit_label)
    plt.grid(True)
    plt.savefig("plots_pot-energy.png", dpi=300)

    
    plt.figure()
    plt.scatter(timefs, vEkin, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Kinetic Energy"+unit_label)
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Kinetic Energy'+unit_label)
    plt.grid(True)
    plt.savefig("plots_kin-energy.png", dpi=300)

    plt.figure()
    plt.scatter(timefs, vTemp, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.title("Temperature (K)")
    plt.xlabel('Time / '+ timeunit_label)
    plt.ylabel('Temperature / K ')
    plt.savefig("plots_temp.png", dpi=300)

# %%
# Functions for --distance and --dihedral
def parse_geom(file_path, atom_count):
    '''Parse one geometry of a time from a XYZ file in TINKER format. '''
    nlines = atom_count + 1
    with open(file_path, 'r') as f:
        while True: 
            block = []
            try:
                for _ in range(nlines):
                    block.append(next(f))
            except StopIteration:
                break
            if len(block) == nlines:
                yield block
        
def get_atom_coords(line): 
    'Extract coordinates from a line like: 2 CA x y z...'
    parts = line.strip().split()
    x,y,z = map(float, parts[2:5])
    return x,y,z

def compute_distance(xyz_atom1, xyz_atom2):
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(xyz_atom1, xyz_atom2)))

def collect_distances(xyz_file, atom_count, atom1_idx, atom2_idx): 
    distances = []
    steps = []
    for i, geom in enumerate(parse_geom(xyz_file, atom_count)):
        coords1 = get_atom_coords(geom[atom1_idx + 1])
        coords2 = get_atom_coords(geom[atom2_idx + 1])
        dist = compute_distance(coords1, coords2)
        distances.append(dist)
        steps.append(i)
    return steps, distances

def plot_distances(step, distance):
        plt.figure()
        ax = plt.gca()
        plt.scatter(step, distance, marker='.' , s=5, color="#6d071a", alpha=0.1)
        plt.ylabel('Atom distance (Angstrom)')
        ax .set_ylim([-5, 5])
        plt.grid(True)
        plt.subplots_adjust(wspace=0.5, hspace=0.5)
        plt.savefig("plots_distance_"+str(atom1_idx)+"-"+str(atom2_idx)+".png", dpi=300)

# %%
def compute_dihedral(coords1, coords2, coords3, coords4):
    coords1, coords2, coords3, coords4 = map(np.array, (coords1, coords2, coords3, coords4))
    
    b0 = coords2 - coords1
    b1 = coords3 - coords2
    b2 = coords4 - coords3
    
    # Normalize b1
    b1 /= np.linalg.norm(b1)

    # Compute cross products and projections
    v = b0 - np.dot(b0, b1) * b1
    w = b2 - np.dot(b2, b1) * b1

    x = np.dot(v, w)
    y = np.dot(np.cross(b1, v), w)

    # Compute dihedral angle in degrees
    angle = np.degrees(np.arctan2(y, x))
    
    return angle

def collect_dihedrals(xyz_file, atom_count, atom1_idx, atom2_idx, atom3_idx, atom4_idx):
    dihedrals = []
    steps = []
    for i, geom in enumerate(parse_geom(xyz_file, atom_count)):
        coords1 = get_atom_coords(geom[atom1_idx + 1])
        coords2 = get_atom_coords(geom[atom2_idx + 1])
        coords3 = get_atom_coords(geom[atom3_idx + 1])
        coords4 = get_atom_coords(geom[atom4_idx + 1])

        dihedral = compute_dihedral(coords1, coords2, coords3, coords4)
        dihedrals.append(dihedral)
        steps.append(i)

    return steps, dihedrals
    
def plot_dihedrals(step, dihedral):
    plt.figure()
    ax = plt.gca()
    plt.scatter(step, dihedral, marker='.' , s=5, color="#6d071a", alpha=0.1)
    plt.ylabel('Dihedral angle')
    ax.set_ylim([-180, 180])
    plt.grid(True)
    plt.subplots_adjust(wspace=0.5, hspace=0.5)
    plt.savefig("plots_dihedral_"+str(atom1_idx)+"_"+str(atom2_idx)+"_"+str(atom3_idx)+"_"+str(atom4_idx)+".png", dpi=300)

# %%
def print_help():
    help_text = """
Usage:
    python script.py --distance <xyz_file> <n_atoms> <atom1_idx> <atom2_idx>

        <xyz_file>   : Path to the TINKER-style XYZ file with multiple geometries
        <n_atoms>    : Number of atoms in each geometry
        <atom1_idx>  : Index (1-based) of the first atom
        <atom2_idx>  : Index (1-based) of the second atom

        -> Computes and plots the distance between two atoms over time.
    
    python script.py --dihedral <xyz_file> <n_atoms> <atom1_idx> <atom2_idx> <atom3_idx> <atom4_idx>

    <xyz_file>   : Path to the TINKER-style XYZ file with multiple geometries
    <n_atoms>    : Number of atoms in each geometry
    <atom1_idx>  : Index (1-based) of the first atom
    <atom2_idx>  : Index (1-based) of the second atom
    <atom3_idx>  : Index (1-based) of the third atom
    <atom4_idx>  : Index (1-based) of the fourth atom
    
        -> Computes and plots the dihedral angle.


    python script.py --energy <dynfile> <plot_type> <unit> <timestep> <timeunit>

        <dynfile>    : TINKER dynamics source file (e.g., .out or .log)
        <plot_type>  : 'subplots' for combined plot or 'plots' for separate plots
        <unit>       : 'ev' or 'kcalmol'
        <timestep>   : Time step in femtoseconds (fs)
        <timeunit>   : 'fs' or 'ps' (for x-axis time unit)

        -> Extracts (if needed) and plots energy and temperature data.

Examples:
    python script.py --distance traj.xyz 42 1 8
    python script.py --energy sim.out subplots kcalmol 1.0 fs
"""
    print(help_text)


def write_file(filename, steps, param):
    with open(filename, 'w') as f:
        f.write("Step \tDistance \n")
        for step, param in zip(steps, param):
            f.write(f"{step}\t{param:.6f}\n")
# %%

if len(sys.argv) < 2 or sys.argv[1] in ['-h', '--help']:
    print_help()
    sys.exit(0)

if sys.argv[1] == '--energy':
    tinker_out  = sys.argv[2] 
    unit        = sys.argv[4] if len(sys.argv) >= 4 else 'ev'
    plot_type   = sys.argv[3] if len(sys.argv) >= 4 else 'plots'
    timestep    = float(sys.argv[5]) if len(sys.argv) >= 6 else 1.0
    timeunit    = sys.argv[6] if len(sys.argv) >= 7 else 'ps'
    energy(tinker_out)

elif sys.argv[1] == '--distance':          
    xyz_file = sys.argv[2]
    atom_count = int(sys.argv[3])
    atom1_idx = int(sys.argv[4]) -1
    atom2_idx = int(sys.argv[5]) -1
    steps, distances = collect_distances(xyz_file, atom_count, atom1_idx, atom2_idx)
    write_file("plot_distance_"+str(atom1_idx)+"-"+str(atom2_idx)+".dat",steps, distances) 
    plot_distances(steps, distances)
    
elif sys.argv[1] == '--dihedral':
    xyz_file = sys.argv[2]
    atom_count = int(sys.argv[3])
    atom1_idx = int(sys.argv[4]) -1
    atom2_idx = int(sys.argv[5]) -1
    atom3_idx = int(sys.argv[6]) -1
    atom4_idx = int(sys.argv[7]) -1
    steps, dihedrals = collect_dihedrals(xyz_file, atom_count, atom1_idx, atom2_idx, atom3_idx, atom4_idx)
    write_file("plot_dihedral_"+str(atom1_idx)+"-"+str(atom2_idx)+"-"+str(atom3_idx)+"-"+str(atom4_idx)+".dat", steps, dihedrals)
    plot_dihedrals(steps, dihedrals)



    

# %%
# tinker_out = 'thermal.out'
# unit = 'ev'
# plot_type = 'plots'
# timestep = '1.0'
# timeunit = 'ps'


# get_ene(tinker_out)

# #energy(tinker_out)

# %% [markdown]
# 


