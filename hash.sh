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
# we can't use 'for x in *' syntax, because it would run in an endless loop
ITEMS="$LOC/*"
for ITEM in $ITEMS; do

	# don't run in an endless loop
	if [ "$ITEM" = "$LOC" ] || [ "$ITEM" = "$SCRIPT" ]; then
		continue
	fi

	# traverse directories, hash files
	if [ -d "$ITEM" ]; then

		# traverse directory
		echo "Traverse $ITEM"
		"$SCRIPT" "$ITEM"
	else

		# hash file
		SUM=$($HASH_BIN "$ITEM"|cut -d' ' -f1)
		echo "mv $ITEM $LOC/$SUM"
		mv "$ITEM" "$LOC/$SUM"
	fi
done
