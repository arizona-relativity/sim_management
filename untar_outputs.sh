#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -d <simulation_directory> -s <start_number> -e <end_number>"
    exit 1
}

# Parse command-line options
while getopts "d:s:e:" opt; do
    case ${opt} in
        d ) SIM_DIR="$OPTARG" ;;
        s ) START_NUMBER="$OPTARG" ;;
        e ) END_NUMBER="$OPTARG" ;;
        * ) usage ;;
    esac
done

# Check if required arguments are provided
if [ -z "$SIM_DIR" ] || [ -z "$START_NUMBER" ] || [ -z "$END_NUMBER" ]; then
    usage
fi

# Convert start and end numbers to 4-digit format
echo $START_NUMBER
echo $END_NUMBER

# Loop through the range and extract each file
for ((i=START_NUMBER; i<=END_NUMBER; i++)); do
    FILE_NUMBER=$(printf "%04d" "$i")
    FILE_PATH="$SIM_DIR/output-$FILE_NUMBER.tar.gz"

    if [ ! -f "$FILE_PATH" ]; then
        echo "Warning: File $FILE_PATH does not exist. Skipping."
        continue
    fi

    echo "Untarring: $FILE_PATH"   
 
    tar -xzf "$FILE_PATH"
    echo "Extraction complete: $FILE_PATH"
done
