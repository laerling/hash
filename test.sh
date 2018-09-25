#!/bin/bash

rm -rf test;
mkdir test; cd test || exit;
for i in {0..9}; do
	mkdir $i; cd $i;
	for j in {0..9}; do
		mkdir $i_$j; cd $i_$j;
		for k in {0..9}; do
			dd if=/dev/urandom of=$i_$j_$k bs=1024 count=1024;
		done;
		cd ..;
	done;
	cd ..;
done;
