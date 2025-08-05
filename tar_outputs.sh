#!/bin/bash

# Example usage:
# ./tar_outputs.sh -d DISK_A20_E015 -s 0 -e 25
# where:
#   -d : Simulation directory (e.g., DISK_A20_E015)
#   -s : Start output number (e.g., 0)
#   -e : End output number (e.g., 25)

# Load environment
source ~/.bashrc

# Usage function
usage() {
    echo "Usage: $0 -d <sim_dir> -s <start_output> -e <end_output>"
    echo "  -d   Simulation directory name (e.g., DISK_A20_E015)"
    echo "  -s   Start output number (e.g., 0)"
    echo "  -e   End output number (e.g., 25)"
    echo "  -h   Show this help message"
    exit 1
}

# Parse flags
while getopts d:s:e:h flag; do
    case "${flag}" in
        d) sim_dir=${OPTARG} ;;
        s) start=${OPTARG} ;;
        e) end=${OPTARG} ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Validate required arguments
if [[ -z "$sim_dir" || -z "$start" || -z "$end" ]]; then
    usage
fi

echo "Simulation Directory: $sim_dir"
echo "Start Output: $start"
echo "End Output: $end"

# Loop through outputs and tar each
for ((i=start; i<=end; i++)); do
    i_form=$(printf "%04d" $i)
    tarname="$sim_dir/output-$i_form.tar.gz"
    tarpath="$sim_dir/output-$i_form/"

    echo "Tarring $tarpath into $tarname"
    tar -czf $tarname $tarpath
    sleep 1s
done

echo "Tarballed $sim_dir outputs $start to $end"

