#!/bin/bash

rm -rf test;
mkdir test; cd test || exit;
for i in {0..3}; do
	mkdir $i; cd $i;
	for j in {0..3}; do
		mkdir $i_$j; cd $i_$j;
		for k in {0..3}; do
			dd if=/dev/urandom of="$i\"$j' $k" bs=1024 count=1024;
			dd if=/dev/urandom of="$i-$j $k" bs=1024 count=1024;
		done;
		cd ..;
	done;
	cd ..;
done;
