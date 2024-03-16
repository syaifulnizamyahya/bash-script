#!/bin/bash
## Descriptions : Script to update attribute value in genders file
## Usage        : ./update.sh <node> <attribute> <value>
## Author       : Syaiful Nizam bin Yahya
## Last revised : 16/03/2024

# Check if the number of arguments is correct
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <node> <attribute> <value>"
    exit 1
fi

# Parse arguments
node="$1"
attr="$2"
value="$3"

# File to update
file=/etc/genders

# Check if file exist
if [ ! -f "$file" ]; then
    echo "File $file not found"
    exit 1
fi

# Check for genders file errors
if ! nodeattr -f "$file" -k > /dev/null 2>&1; then
    echo "Error opening genders file $file"
    exit 1
fi

# Check if node and attribute exist
if ! nodeattr -f "$file" -Q "$node" "$attr"; then
    echo "Node $node or attribute $attr not found"
    exit 1
fi

# Update attribute
sed -i "s/\($node .*,$attr\)[^,]*/\1=$value/" "$file"

# Check if update was successful
if ! nodeattr -f "$file" -Q "$node" "$attr=$value"; then
    echo "Failed to update attribute $attr for node $node to $value"
    exit 1
fi
