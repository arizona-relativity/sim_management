#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -d <simulation_directory> -s <start_output> -e <end_output>"
    exit 1
}

# Parse command-line options
while getopts "d:s:e:" opt; do
    case ${opt} in
        d ) SIM_DIR="$OPTARG" ;;   # Simulation directory
        s ) START_OUTPUT="$OPTARG" ;;  # Start output
        e ) END_OUTPUT="$OPTARG" ;;    # End output
        * ) usage ;;
    esac
done

# Check if required arguments are provided
if [ -z "$SIM_DIR" ] || [ -z "$START_OUTPUT" ] || [ -z "$END_OUTPUT" ]; then
    usage
fi

# Loop through the range and collect files
for ((i=START_OUTPUT; i<=END_OUTPUT; i++)); do
    # Convert the output number to a 4-digit format
    OUTPUT_NUM=$(printf "%04d" "$i")
    OUTPUT_DIR="$SIM_DIR/output-$OUTPUT_NUM/disk"

    # Check if the directory exists
    if [ ! -d "$OUTPUT_DIR" ]; then
        echo "Warning: Directory $OUTPUT_DIR does not exist. Skipping."
        continue
    fi

    # Tar all 2D files from one output into a single tarball at the $SIM_DIR level
    tar -cvf "$SIM_DIR/analysis_$OUTPUT_NUM.tar.gz" \
        "$OUTPUT_DIR/rho_b.xy.h5" \
        "$OUTPUT_DIR/P.xy.h5" \
        "$OUTPUT_DIR/smallb2.xy.h5" \
	"$OUTPUT_DIR/volume_integrals-GRMHD.asc" \
        "$OUTPUT_DIR/diskdiagnostics-hor_fluxes..asc" \
        "$OUTPUT_DIR/quasilocalmeasures-qlm_scalars..asc" \
        $OUTPUT_DIR/h.ah* \
        $OUTPUT_DIR/BH_diagnostics*
        #$OUTPUT_DIR/*_T_rph_bh*.xy.h5
    echo "Files for output-$OUTPUT_NUM have been tarred."
done

