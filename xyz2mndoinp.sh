input_file="$1"
output_file="${input_file}.mndo"

while IFS= read -r line; do
    # Check if the line contains coordinates
    if [[ $line =~ ^[[:space:]]*([A-Za-z]+)[[:space:]]+([-0-9.]+)[[:space:]]+([-0-9.]+)[[:space:]]+([-0-9.]+)$ ]]; then
        atom="${BASH_REMATCH[1]}"
        x="${BASH_REMATCH[2]}"
        y="${BASH_REMATCH[3]}"
        z="${BASH_REMATCH[4]}"
        
        # Modify the atom labels
        if   [[ $atom == "C" ]]; then
            atom="6"
        elif [[ $atom == "N" ]]; then
            atom="7"
        elif [[ $atom == "H" ]]; then 
            atom="1"
        elif [[ $atom == "O" ]] ; then 
            atom="8" 
        fi

        # Write the formatted line to the output file
        printf "%2s%12s%3s%12s%3s%12s%3s\n" "$atom" "$x" "1"  "$y"  "1"  "$z"  "1" >> "$output_file"
    else
        # Write the line as is to the output file
        echo "$line" >> "$output_file"
    fi
done < "$input_file"

printf "%2s%12s%3s%12s%3s%12s%3s\n" " " "0.0" "0" "0.0" "0" "0.0" "0" >> "$output_file"
