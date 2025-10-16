#!/bin/bash

export balance1=$(sam-balance -A lcomputational_photochemistry | tail -1 | awk '{print $3}')
export available1=$(sam-balance -A lcomputational_photochemistry | tail -1 | awk '{print $5}')

export balance2=$(sam-balance -A lp_computational_photochemistry-small | tail -1 | awk '{print $3}')
export available2=$(sam-balance -A lp_computational_photochemistry-small | tail -1 | awk '{print $5}')

python3 <<EOF

import os
balance1=float(os.environ.get('balance1'))
available1=float(os.environ.get('available1'))


balance2=float(os.environ.get('balance2'))
available2=float(os.environ.get('available2'))

amount_avail1 = available1 / balance1 * 100
amount_avail2 = available2 / balance2 * 100

print ("")
print ("Credit usage:")
print (f"computational_photochemistry: {amount_avail1:.1f}% free")
print (f"computational_photochemistry-small: {amount_avail2:.1f}% free")

if amount_avail1 < 30  or amount_avail2 < 30 : 
    print("")
    print("WARNING:")
    print("Amount of available resources is dangerously low!") 
    print("Ask Daniel for a top-up!")
    print("")

EOF


