#!/bin/bash

# Define the output files
output_file1="/tmp/capture_logs1.txt"
output_file2="/tmp/capture_logs2.txt"
output_file3="/tmp/capture_logs3.txt"

# Temporary file for rotation
output_file_tmp="/tmp/capture_logs_tmp.txt"

# Maximum size of each output file in bytes (10MB)
max_file_size=10485760

# Initialize output_file to the first file
output_file="$output_file1"

# Function to capture grep output
capture_grep() {
    printf "\ngrep -r \"\" /sys/block/nvme*n1/inflight ran at %s\n\n" "$(date)" >> "$output_file"
    grep -r "" /sys/block/nvme*n1/inflight >> "$output_file" 2>&1
}

# Function to capture ps aux -L output
capture_ps_aux_L() {
    printf "\nps aux -L ran at %s\n\n" "$(date)" >> "$output_file"
    ps aux -L >> "$output_file" 2>&1
}

# Function to capture cat /proc/meminfo output
capture_meminfo() {
    printf "\ncat /proc/meminfo ran at %s\n\n" "$(date)" >> "$output_file"
    cat /proc/meminfo >> "$output_file" 2>&1
}

# Function to capture nstat -a output
capture_nstat() {
    printf "\nnstat -a ran at %s\n\n" "$(date)" >> "$output_file"
    nstat -a >> "$output_file" 2>&1
}

# Function to check and recreate the output file if it exceeds the maximum size
check_file_size() {
    if [ -f "$output_file" ] && [ $(stat -c %s "$output_file") -gt $max_file_size ]; then
        rotate_files
    fi
}

# Function to rotate output files
rotate_files() {
    # Check if the files exist before attempting to move them
    if [ -f "$output_file3" ]; then
        mv "$output_file3" "$output_file_tmp"
    fi
    if [ -f "$output_file2" ]; then
        mv "$output_file2" "$output_file3"
    fi
    if [ -f "$output_file1" ]; then
        mv "$output_file1" "$output_file2"
    fi
    touch "$output_file1"
    output_file="$output_file1"
}

# Run the function in a loop
while true; do
    check_file_size
    capture_grep
    capture_ps_aux_L
    capture_meminfo
    capture_nstat
    # Wait for 10 seconds
    sleep 10
done
