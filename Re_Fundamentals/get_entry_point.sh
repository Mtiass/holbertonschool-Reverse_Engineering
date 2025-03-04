#!/bin/bash

# Check if a file is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

# Get the file name from the argument
file_name="$1"

# Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# Check if the file is a valid ELF file
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: File '$file_name' is not a valid ELF file."
    exit 1
fi

# Extract information using readelf
magic_number=$(readelf -h "$file_name" | awk '/Magic:/ {for (i=2; i<=NF; i++) printf $i " "; print ""}')
class_format=$(readelf -h "$file_name" | awk '/Class:/ {print $2}')
byte_order_raw=$(readelf -h "$file_name" | awk '/Data:/ {print $2}')
entry_point=$(readelf -h "$file_name" | awk '/Entry point address:/ {print $4}')

# Format Byte Order to human readable (little or big endian)
if [[ "$byte_order_raw" == "2's" ]]; then
    byte_order="little endian"
elif [[ "$byte_order_raw" == "1" ]]; then
    byte_order="big endian"
else
    byte_order="unknown"
fi

# Set variables to match messages.sh expectations
class="$class_format"
entry_point_address="$entry_point"

# Now call the messages.sh to format and display the extracted information
source ./messages.sh
display_elf_header_info
