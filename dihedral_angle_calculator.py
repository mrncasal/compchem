#!/usr/bin/python3

import numpy as np
import pandas as pd
import argparse

# INTERACTIVE VARIABLES
#parser.add_argument('xyz_file')
#parser.add_argument('atom1')
#parser.add_argument('atom2')
#parser.add_argument('atom3')
#parser.add_argument('atom4')

#atom1 = args.atom1 
#atom2 = args.atom2
#atom3 = args.atom3
#atom4 = args.atom4

# FIXED VARIABLES
atom1 = 3
atom2 = 6
atom3 = 8
atom4 = 13

# FILE = args.file
FILE = 'opt_geometry.xyz'

with open(FILE) as file:
    geometry_file = file.readlines()

###############################################################################################
# MANIPULATION OF XYZ FILE                                                                  ###
###############################################################################################

# Deletes first two lines
geometry = geometry_file[2:]
# Split each line of file in a list of strings
geometry = [geo.lstrip(" ").rstrip("\n").split() for geo in geometry]
# Transforms in table
geometry_data = pd.DataFrame(geometry)
# Name the columns
geometry_data.columns=["Atoms", "x", "y", "z"]
# Makes sure numbers are float
geometry_data["x"] = geometry_data["x"].astype(float)
geometry_data["y"] = geometry_data["y"].astype(float)
geometry_data["z"] = geometry_data["z"].astype(float)

# Set atoms indexes

# ATOM1_IDX = int(args.atom1)-1
# ATOM2_IDX = int(args.atom2)-1
# ATOM3_IDX = int(args.atom3)-1
# ATOM4_IDX = int(args.atom4)-1

ATOM1_IDX = int(atom1)-1
ATOM2_IDX = int(atom2)-1
ATOM3_IDX = int(atom3)-1
ATOM4_IDX = int(atom4)-1

def initial_vectors():
    """Function to set up initial vectors"""
    
    # Set initial values for arrays
    ATOM1_VECTOR = np.zeros(3)
    ATOM2_VECTOR = np.zeros(3)
    ATOM3_VECTOR = np.zeros(3)
    ATOM4_VECTOR = np.zeros(3)
    
    # Set initial coordinates
    ATOM1_VECTOR = geometry_data.iloc[ATOM1_IDX].tolist()[1:]
    ATOM2_VECTOR = geometry_data.iloc[ATOM2_IDX].tolist()[1:]
    ATOM3_VECTOR = geometry_data.iloc[ATOM3_IDX].tolist()[1:]
    ATOM4_VECTOR = geometry_data.iloc[ATOM4_IDX].tolist()[1:]

    return ATOM1_VECTOR, ATOM2_VECTOR, ATOM3_VECTOR, ATOM4_VECTOR

def calc_q_vectors(ATOM1_VECTOR, ATOM2_VECTOR , ATOM3_VECTOR, ATOM4_VECTOR ):
    """Function to calculate q vectors"""
    
    #Calculate coordinates for vectors q1, q2 and q3
    q1 = np.subtract(ATOM2_VECTOR, ATOM1_VECTOR)
    q2 = np.subtract(ATOM3_VECTOR, ATOM2_VECTOR)
    q3 = np.subtract(ATOM4_VECTOR, ATOM3_VECTOR)
    
    return q1, q2, q3
    

def calc_cross_vectors (q1, q2, q3):
    """Function to calculate cross vectors"""
    
    # Calculte cross vectors
    q1_x_q2 = np.cross(q1,q2)
    q2_x_q3 = np.cross(q2,q3)
    
    return q1_x_q2 , q2_x_q3

def calc_normals (q1_x_q2, q2_x_q3):
    """Function to calculate normal vectors to planes"""
    
    #Calculate normal vectors
    n1 = q1_x_q2/np.sqrt(np.dot(q1_x_q2, q1_x_q2))
    n2 = q2_x_q3/np.sqrt(np.dot(q2_x_q3, q2_x_q3))
    
    return n1, n2
    
def calc_orthogonal_unit_vectors(n2, q2):
    """ Function to calculate orthogonal unit vectors"""
    
    # Calculate unit vectors
    u1 = n2
    u3 = q2/(np.sqrt(np.dot(q2,q2)))
    u2 = np.cross(u3, u1)
    
    return u1, u2, u3

def calc_dihedral_angle(n1, u1, u2, u3):
    """Function to calculate dihedral angle"""
    
    import math
    
    # Calculate cosine and sine
    cos_theta = np.dot(n1,u1)
    sin_theta = np.dot(n1,u2)
    
    # Calculte theta
    theta = -math.atan2(sin_theta, cos_theta)
    theta_deg = np.degrees(theta)
    
    # Show results
    print ("%8.3f"%theta_deg)


def main():
    # Call initial_vectors() functions
    ATOM1_VECTOR, ATOM2_VECTOR, ATOM3_VECTOR, ATOM4_VECTOR = initial_vectors()
           
    # Call calc_q_vectors(ATOM1_VECTOR, ATOM2_VECTOR , ATOM3_VECTOR, ATOM4_VECTOR) function
    q1,q2,q3 = calc_q_vectors(ATOM1_VECTOR, ATOM2_VECTOR , ATOM3_VECTOR, ATOM4_VECTOR)
           
    # Call calc_cross_vectors(q1,q2,q3) function
    q1_x_q2, q2_x_q3 = calc_cross_vectors(q1,q2,q3)
           
    # Call calc_nornalss(q1_x_q2,q2_x_q3) function
    n1, n2 = calc_normals(q1_x_q2,q2_x_q3)
           
    # Call calc_orthogonal_unit_vectors(n2,q2) function
    u1,u2,u3 = calc_orthogonal_unit_vectors(n2,q2)
           
    # Call calc_dihedral_angle(u1,u2,u3) function
    calc_dihedral_angle(n1,u1,u2,u3) 
    
main()

