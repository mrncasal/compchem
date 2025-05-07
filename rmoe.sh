#!/bin/bash


if [[ "$1" == "out" ]]; then 
    files+=" "$(ls *out statistics* ddens CC* energy JOB_INFO restart* rmfile syminfo 2>/dev/null)
fi

# Find files matching the pattern *.[oe][1-9]*
files+=" "$(ls *.[oe][1-9]* *job 2>/dev/null)

# Check if any files match the pattern
if [ "$files" == " " ]; then
    echo "No files to be deleted."
else
    echo " "
    echo "You are going to delete the following files:"
    echo "$files"

    # Ask user if they want to remove the files
    read -p "Do you want to remove these files? (y/n): " choice

    # Sets default value
    choice=${choice:-Y}

    case "$choice" in
        y|Y)
            # Remove the files
            rm $files
            echo "Files removed."
            ;;
        n|N)
            echo "No files were removed."
            ;;
        *)
            echo "Invalid choice. No files were removed."
            ;;
    esac
fi

