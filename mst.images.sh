#! /bin/bash

# COMO USAR:
# bash mst.spt name.file.without.xyz

sed "1 i\load $1.xyz" ~/scripts/mst.spt > mst.spt
#sed -i "s/file/$1.png/" mst.spt 
sed -i "s/file/$1.jmol/" mst.spt
java -jar /home/mrncasal/Downloads/jmol-14.29.29/Jmol.jar -n mst.spt $1.xyz
