#!/usr/bin/perl

use strict;
use warnings;

# initialize constants
my $HASH_BIN = "md5sum";

# initialize variables
my $script = $0;
my $loc = shift || ".";
my $rename = shift || "";

# check location
die "Error: $loc is not a directory" unless -d $loc;

# check safety
if($rename) {
    print "WARNING: Renaming files in '$loc'. Continue? (y/N) ";
    my $ok = <>; # ask for user input
    if($ok ne "y\n"){
	print "Exiting.\n";
	exit;
    }
}

# read dir
opendir(my $dir, $loc);
while(my $item = readdir $dir){

    # exclude ., .., and .git
    next if $item =~ /^(\.|\.\.)$|\.git/;

    # canonize $loc and build path
    $loc = $loc . "/" unless substr($loc, -1) eq '/';
    my $itempath = "$loc$item";

    # traverse or hash
    if(-d $itempath){

	# traverse directory
	system($script, $itempath);
    } else {

	# calculate hash
	`$HASH_BIN '$itempath'` =~ /(^[\S]+)/;
	die "$HASH_BIN output could not be parsed" if not defined $1;
	my $hash = $1;

	# print hash
	print "$hash '$itempath'\n";

	# rename file
	if($rename){
	    system("mv", "$itempath", "$loc$hash");
	}
    }
}
