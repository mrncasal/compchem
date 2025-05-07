#!/bin/bash

radical=${1%.log}

# finds the last file with the pattern filename.[number].log
last_file=$(ls ${radical}.*.log 2>/dev/null | sort -V | tail -n 1)

get_curr_suffix() {
    if [ -f "${radical}.log" ] ; then
        if [ -z "$last_file" ]; then
            next_number=1
        else 
            number=$(echo "$last_file" | grep -oP '(?<=\.)[0-9]+(?=\.log)')
            next_number=$((number + 1))
        fi
    else 
        echo "No ${radical}.log found."
    fi

} 

add_suffix() {
    file_type=$1

    if [ -f "${radical}.${file_type}" ]; then
        mv "${radical}.${file_type}" "${radical}.${next_number}.${file_type}"
        echo "Moved ${radical}.${file_type} to  ${radical}.${next_number}.${file_type}"
    fi 
}

if [ $1 == "-h" ] ; then
    echo "" 
    echo "This script will append filename.x.suffix, where x=1 if none exist or x=x+1 otherwise."
    echo "This will also modify .molden, .log, .xyz, .chk, .fchk if present."
    echo "Usage: script log_file"
    echo "" 
    exit 0
fi

get_curr_suffix
add_suffix "log"
add_suffix "xyz"
add_suffix "molden" 
add_suffix "chk"
add_suffix "fchk"
