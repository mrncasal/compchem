#!/bin/bash

file=$1

#default values
max_states=2
print_level=2


# check if it is a optimization file 
function check_keyword () {

if n=$(grep -wic "$1" $2); then
    echo True
else
    echo False
fi
}

# check for parsing option
while [[ $# -gt 0 ]] ; do 
    key="$1"

    case $key in 

    -h|--help)
    echo
    echo "Syntax: command file [-p] [print_level] [-s] [max_states]"
    echo "print_level=1 : headers, state label,  ev, nm and f will be printed"
    echo "print_level=2 : only ev and f will be printed. Default."
    echo
    exit 1
    ;;

    -p|--print_level)
     print_level="$2"
     shift 2
     ;;

    -s|--max_states)
    max_states="$2"
    shift 2
     ;;

    *)
    shift 1
    ;;
esac
done

# check for keywords
opt=$(check_keyword "OPT" "$file")
exc_st=$(check_keyword "Excited State" "$file")

# exit if not a file containing excitation energies
if [ $exc_st == "False" ] ; then
    exit 0
fi


if [ $opt == "True" ] ; then

# If the file is a geometry optimization
	echo  
        echo "$file is a geometry optimization file."
	echo 'Energies of the last cycle will be printed instead.'
	echo 'Proceed carefully.'
	echo 
	echo  

        # header
	if [[ $print_level > 1 ]]; then
	  printf "%-3s %9s\n" "eV" "f"
        else
	  printf  ${file%.log}
          printf "%3s %3s %8s %7s\n" "State" "eV" "nm" "f"
	fi

	for state in $(seq $max_states); do
            string=$(grep "Excited State   $state" $file | tail -n 1 )
            read -ra array  <<< "$string"

            # some cosmetics
            state=$(echo "${array[2]}" | sed 's/://')
            ev=$(echo "${array[4]}")
            nm=$(echo "${array[6]}")
            f=$(echo "${array[8]}" | sed 's/f=//')
	    if [[ $print_level == 2 ]]; then
                printf "%1s %11s %8s %8s\n"  $ev $f
	    else 
	        printf "%1s %11s %8s %8s\n" $state $ev $nm $f
            fi
	
        done
else

# If it is not a geometry optimization
    	if [[ $print_level > 1 ]]; then
#    	  printf "\n"
    	  printf "%-3s %9s\n" "eV" "f"
            else
#    	  printf "\n"
    	  printf "${file%.log}\n"
              printf "%3s %3s %8s %7s\n" "State" "eV" "nm" "f"
    	fi
            
    	for state in $(seq $max_states); do 
            	string=$(grep "Excited State   $state" $file)
            	read -ra array  <<< "$string"
            
            	# some cosmetics
            	state=$(echo "${array[2]}" | sed 's/://')
            	ev=$(echo "${array[4]}")
            	nm=$(echo "${array[6]}")
            	f=$(echo "${array[8]}" | sed 's/f=//')
                   
                    if [[ $print_level == 2 ]]; then
                         printf "%1s %11s %8s %8s\n"  $ev $f
#                         printf "\n"
    	        else 
    	             printf "%1s %11s %8s %8s\n" $state $ev $nm $f
 #                    printf "\n"
                    fi
    	done
fi
