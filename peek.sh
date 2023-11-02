#usr/bin/bash

file="$1"
lines="${2:-3}"  #We use :- to provide a default value for a variable if the variable is unset or empty

total_lines=$(wc -l < "$file")

if [[ "$total_lines" -le $((2 * lines)) ]]; then
    cat "$file"
else
    head -n "$lines" "$file"
    echo "..."
    tail -n "$lines" "$file"
fi
