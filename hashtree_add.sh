#!/usr/bin/bash

file=$(realpath "$1")
if [ ! -f "$file" ]; then
    exit 0;
fi

sum=$(md5sum "$file" | cut -d' ' -f1)
part1=$(echo -n "$sum" | cut -b1-2)
part2=$(echo -n "$sum" | cut -b3-4)

hashfile=~/hashes/"$part1/$part2/$sum"
echo "$hashfile += $file"

# create directories if not already present
mkdir -p ~/hashes/"$part1"/"$part2"/

# write filename to hashfile
echo "$file" >> ~/hashes/"$part1"/"$part2"/"$sum"
