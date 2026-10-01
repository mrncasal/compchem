#!/bin/bash

prefix=$1

if [[ -z "$prefix" ]] ; then
    echo "Usage: scrip file_prefix"
    exit 1
fi

if [[ ! -f "dens_ana.in" ]] ; then
    echo "A template for dens_ana.in is needed!"
    echo "This script will replace the string 'template'"
    echo "with the appropriate name."
    cat > dens_ana.in << 'EOF'
rtype='cclib'
rfile='template.log'
mo_file='template.molden'
comp_ntos=True
comp_dntos=False
jmol_orbitals=True
molden_orbitals=False
EOF
fi

# Expanding the missing wildcard to nothing
shopt -s nullglob
chk_files=( "${prefix}"*.chk )
 
if (( ${#chk_files[@]} == 0 )); then
    echo "No ${prefix}*.chk files found." >&2
    exit 1
fi
 
for chk in "${chk_files[@]}" ; do
 
    dir=${chk%.chk}
 
    # Generating molden files
    if ! /usr/local/chem/g16A03/formchk "$dir.chk" ; then
        echo "formchk failed for $dir.chk, skipping." >&2
        continue
    fi
    /home/mariana/.scripts/compchem/gau2molden.sh "$dir.fchk"
 
    # Running TheoDORE
    mkdir -p "$dir.theo"
    sed -e "s|template|../$dir|g" dens_ana.in > "$dir.theo/dens_ana.in"
    ( cd "$dir.theo" && theodore analyze_tden > theo.out ) \
        || echo "TheoDORE failed for $dir." >&2

    ( cd "$dir.theo" && java -jar ~/.softwares/jmol-14.32.80/Jmol.jar -n nto_jmol.spt > jmol.out ) \
        || echo "Jmol failed for $dir." >&2

done
