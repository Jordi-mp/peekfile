#!/bin/bash 

echo " "
echo MSc in Bioinformatics for Health Sciences
echo Introduction to Algorithmics
echo "Jordi Martín Pérez (u235858)"
echo Midterm assignment: Fastascan
echo " "
echo "........................................................................."
echo " "

# 1. the folder X where to search files (default: current folder) 
Folder="${1:-$PWD}"  # ":-" is used as a default value operator 
# 2. a number of lines N (default: 0)
Lines="${2:-0}"  

# Find fasta/fa files 
F=$(find "$Folder" -type f -name "*.fa" -o -name "*.fasta")

# Count the number of fasta/fa files 
echo "Number of fasta/fa files is: $(echo "$F" | wc -l)" 

# Count the number of unique fasta IDs 
echo "Number of unique fasta IDs: $(grep "^>" $F | sort -u | wc -l)" 
# grep prints matching lines and we use "^>" to match a greater-than symbol (>) only if it appears at the beginning of a line (^).
# sort -u is used to remove duplicate lines, as we want to count the number of UNIQUE fasta IDs (equivalent to sort + unique).

echo " "
echo Report of the files:
echo "........................................................................."
echo " "

# Process each file 
for i in $F; do 

# Print a nice header including filename 
echo "Processing file: $i" 

# Determine if the file is nucleotide or amino acids based on content 
if grep -Eq '^[ACGTN]+$' "$i" 
then echo "Type: Nucleotide fasta" 
else echo "Type: Protein fasta"
 fi 
 
# To determine if the file is a nucleotide or amino acid fasta, we are going to suppose that the amino acid sequences are not only composed of A,T,C or G. 
# The grep -Eq '^[ACGTN]+$' "$i" command searches for patterns in a file, utilizing extended regular expressions (-E) and suppressing output (-q)
# and the enclosed pattern '^[ACGTN]+$' anchors to the beginning and end of the line, specifying a character class matching A, C, G, T, or N (when nucleotide is not specified), and the
# + quantifier for "one or more" occurrences.

# Number of sequences 
echo "Number of sequences: $(grep -c ">" "$i")" 

# Total sequence length (excluding gaps, spaces, newline characters) 
echo "Sequence length: $(sed -n '/>/! { s/-//g; s/[[:space:]]//g; s/\n//g; p; }' "$i" | wc -m)"

# We can breakdown this command, as it might be the most difficult and it includes some functions whcih have not been explicitly explained in class:
# - (sed -n '/>/!): sed -n supresses automatic printing. When combined with '/>/!, the neagtion indicates not to print the headers of the sequences (starting with >).
# - (s/-//g; s/[:space:]//g; s/\///g; p;) : here we are using the structure of replacements in sed to exclude gaps(-), spaces ([:space:]) and new line characters (\n) from being counted.
# g is used to cause the cahnge in all occurrences and the final p is used to print the file applying the replacements.
# - (wc -m): we had already seen the word count command. However, we are used to applying the function -l for line counting, while -m in wc -m is used to indicate character count.
                                                                                                            

# Check if the file is a symlink
 if [[ -h "$i" ]]; 
then echo "Symlink: Yes"
else echo "Symlink: No" 
fi 
echo " "

# Display file content
if [[ $Lines -gt 0 ]]
then
echo "File content:"
 if [[ "$(wc -l < "$i")" -le $((2 * $Lines)) ]];
 then cat "$i" 
elif [[ "$(wc -l < "$i")" -eq 0 ]];
 then echo "It has 0 lines" 
else head -n "$Lines" "$i"
 echo "..." 
tail -n "$Lines" "$i" 
fi
fi
echo " "
echo " "
echo Report of $i finished.
echo " "
echo "........................................................................."
echo " "
done
echo " "
echo Report of all fasta files in $1 finished!
echo " "
