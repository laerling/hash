#!/usr/bin/bash


shopt -s nullglob # don't expand pattern to ~/hashes/xx/xx/\*, thus creating that file

for d1 in ~/hashes/*; do
    echo "Cleaning in $d1..."
    for d2 in "$d1"/*; do
	for hashfile in "$d2"/*; do

	    line_amount_old=$(wc -l "$hashfile" | cut -d' ' -f1)

	    # sort lines in hashfile and remove doubles
	    tempfile=~/temp
	    sort -o "$tempfile" "$hashfile"
	    uniq < "$tempfile" > "$hashfile"

	    line_amount=$(wc -l "$hashfile" | cut -d' ' -f1)
	    if (("$line_amount_old" != "$line_amount")); then
	    	echo "$hashfile: Had $line_amount_old lines, now has $line_amount"
	    fi
	done
    done
done
