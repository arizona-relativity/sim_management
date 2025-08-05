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

    echo "Tarring 2D data for $OUTPUT_NUM"

    tar -czf "$SIM_DIR/condensed_$OUTPUT_NUM.tar.gz" \
        $OUTPUT_DIR/rho_b.xy.h5 \
        $OUTPUT_DIR/rho_b.xz.h5 \
        $OUTPUT_DIR/P.xy.h5 \
        $OUTPUT_DIR/P.xz.h5 \
        $OUTPUT_DIR/smallb2.xy.h5 \
        $OUTPUT_DIR/smallb2.xz.h5 \
        $OUTPUT_DIR/volume_integrals-GRMHD.asc \
        $OUTPUT_DIR/diskdiagnostics-hor_fluxes..asc \
        $OUTPUT_DIR/quasilocalmeasures-qlm_scalars..asc \
        $OUTPUT_DIR/h.ah* \
        $OUTPUT_DIR/BH_diagnostics*

    # If the output is a multiple of 10, include the Bx, By, Bz, rho_b, and P 3D data files
    if (( i % 10 == 0 )); then
        echo "Tarring 3D data for $OUTPUT_NUM"
        tar -czf "$SIM_DIR/3d-$OUTPUT_NUM.tar.gz" \
            $OUTPUT_DIR/Bx.xyz.file_*.h5 \
            $OUTPUT_DIR/By.xyz.file_*.h5 \
            $OUTPUT_DIR/Bz.xyz.file_*.h5 \
            $OUTPUT_DIR/rho_b.xyz.file_*.h5 \
            $OUTPUT_DIR/P.xyz.file_*.h5 \
            $OUTPUT_DIR/vx.xyz.file_*.h5 \
            $OUTPUT_DIR/vy.xyz.file_*.h5 \
            $OUTPUT_DIR/vz.xyz.file_*.h5
    fi

    echo "Files for output-$OUTPUT_NUM have been tarred."
done

