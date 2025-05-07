#!/bin/bash

dirs="$1"
shift

for dir in $dirs* ; do 
	for keyword in "$@" ; do 
	case $keyword in 
	"cartesian")
                if ! grep -q  "COORDS       =   CARTESIAN" $dir/fcc.out; then
		echo "$dir - NOT cartesian "
		else
		echo "$dir - cartesian"
                fi ;; 

	"internal")
		if ! grep -q "COORDS       =   INTERNAL" $dir/fcc.out ; then
		echo "$dir - NOT internal"
		else 
		echo "$dir - internal"
		fi ;;
	"ht")
		if ! grep -q "DIPOLE       =   HTi" $dir/fcc.out ; then
		echo "$dir - NOT HT"
		else 
		echo "$dir - HT"
		fi ;;
	"fc")
                if ! grep -q "DIPOLE       =   FC" $dir/fcc.out ; then
		echo "$dir NOT FC"
		else
		echo "$dir - FC"
		fi ;;
        "broad")
		broad=$(grep "HWHM         =" $dir/fcc.out | awk '{print $3}')
		echo "broad = " $broad ;;
	esac
	done

echo ""
done

#$$$
#;GENERAL OPTIONS:
#; NAT        = (read from structure files)
#; NVIB       = (determined vibrational analysis)
#PROPERTY     =   EMI
#MODEL        =   AH
#DIPOLE       =   HTi
#DIPDER_COORD =   CARTESIAN
#TEMP         =   298.00
#DE           =  (read)
#BROADFUN     =   GAU
#HWHM         =   0.0010
#RESOL        =   0.0001  ; (default: HWHM/10)
#METHOD       =   TD
#ROT          =   2
#SPCMIN       =  (estimated)
#SPCMAX       =  (estimated)
#;VIBRATIONAL ANALYSIS
#NORMALMODES  =   COMPUTE
#RM_COORD     =   NONE
#COORDS       =   CARTESIAN
#FORCE_REAL   =   NO
#;INPUT DATA FILES
#STATE1_FILE  =   enol-4opt-w.fcc
#STATE2_FILE  =   enol-0opt-w.fcc
#MASS_FILE    =
#ELDIP_FILE   =   eldip_enol-4opt-w.fcc
#MAGDIP_FILE  =
#NAC_FILE     =
#NRCOUP_FILE  =   eldip_enol-4opt-w.fcc
#HESS1_FILE   =   enol-4opt-w.fcc
#HESS2_FILE   =   enol-0opt-w.fcc
#GRAD1_FILE   =   enol-4opt-w.fcc
#GRAD2_COORD  =   CARTESIAN
#GRAD2_FILE   =   enol-0opt-w.fcc
#;VERBOSE LEVEL
#VERBOSE      =   1
