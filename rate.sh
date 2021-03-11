#!/usr/bin/bash

script=$(basename "$0")

# check arguments
if [ $# -lt 1 ]; then
    echo "Error: Not enough arguments."
    echo "Usage: $script <directory containing the files to be ranked>"
    exit 1
fi

# check directory
dir=$(realpath "$1")
if [ ! -d "$dir" ]; then
    echo "$1 is not a directory"
    exit 1
fi

# establish the first order
count=0
for item in "$dir/"*; do
    items[count]="$item"
    count=$((count+1))
done

# check amount of files
if [ "$count" -lt "2" ]; then
    echo "Error: Not enough items to rate"
    exit 1
fi

# main loop
run="run"
while [ -n "$run" ]; do

    # choose files
    i1=$((RANDOM % count))
    i2=$i1
    while [ $i1 -eq $i2 ]; do
	i2=$((RANDOM % count))
    done
    item1=${items[$i1]}
    item2=${items[$i2]}

    # show files
    (mpv --mute=yes --loop "$item1" &> /dev/null) & pid1="$!"
    sleep 1 # sleep a bit in order to guarantee (more or less) that the first mpv opens before the second
    (mpv --mute=yes --loop "$item2" &> /dev/null) & pid2="$!"

    # present alternatives
    name1=$(basename "$item1")
    # FIXME: It's not always two digits at the beginning of the filename
    name1="${name1/#[[:digit:]][[:digit:]] /}"
    name2=$(basename "$item2")
    name2="${name2/#[[:digit:]][[:digit:]] /}"
    echo "(1) $name1"
    echo "(2) $name2"

    # ask user
    choice="0"
    while [ -n "$choice" ] && [ "$choice" != "s" ] && [ "$choice" != "1" ] && [ "$choice" != "2" ]; do
	read -rp "Which is better? (s to skip, <enter> to rate and exit, <C-c> to abort) " choice
    done

    # close files
    kill "$pid1"
    kill "$pid2"

    # exit or skip
    case "$choice" in
	"" ) run="" ;;
	"s" ) continue ;;
    esac

    # swap
    if ( [ $i1 -lt $i2 ] && [ "$choice" = "2" ] ) ||
	   ( [ $i2 -lt $i1 ] && [ "$choice" = "1" ] ); then
	items[$i1]=$item2
	items[$i2]=$item1
    fi
done

# rename files to bring them into the correct order
for (( i=0; $i<$count; i=$((i+1)) )); do

    # generate parts for new name
    path=${items[$i]}
    name=$(basename "$path")
    name="${name/#[[:digit:]][[:digit:]] /}"
    prefix=$((i+1)) # one-indexed

    # add padding
    while [ ${#prefix} -lt ${#count} ]; do
    	prefix="0$prefix"
    done

    # move
    # this could overwrite a file, if e. g. '01 name' and '02 name' were swapped
    newpath="$dir/$prefix $name"
    if [ "$path" != "$newpath" ]; then
	mv "$path" "$newpath"
    fi
done
