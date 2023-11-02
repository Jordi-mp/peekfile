#usr/bin/bash

file="$1"
lines="${2:-3}" 

total_lines=$(wc -l < "$file")

if [[ "$total_lines" -le $((2 * lines)) ]]; then
    cat "$file"
else
    head -n "$lines" "$file"
    echo "..."
    tail -n "$lines" "$file"
fi
