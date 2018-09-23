#!/usr/bin/bash

# initialize variables
HASH_BIN=md5sum
SCRIPT=$0
LOC=$1
if [ -z "$LOC" ]; then
	LOC=.
fi

# check argument
if [ ! -d "$LOC" ]; then
	echo "Error: $LOC is not a directory" >&2
	exit 1
fi

# recurse
# Don't use 'for x in *' syntax because that can't handle whitespace in filenames
find "$LOC" | while read ITEM
do

	# don't run in an endless loop
	if [ "$ITEM" = "$LOC" ]; then
		continue
	fi

	# traverse directories, hash files
	if [ -d "$ITEM" ]; then

		# traverse directory
		"$SCRIPT" "$ITEM"
	else

		# hash file
		SUM=$($HASH_BIN "$ITEM"|cut -d' ' -f1)
		echo "$SUM '$ITEM'"
	fi
done
