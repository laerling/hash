#!/usr/bin/bash


if [ ! -e ./hashtree_add.sh ]; then
    echo "You have to execute this script from its own directory"
    exit
fi

echo "Warning: If you interrupt this script, you have to call ./hashtree_clean.sh manually."
find "$1" -not -path ~/'hashes/*' -exec ./hashtree_add.sh {} ';' && ./hashtree_clean.sh
