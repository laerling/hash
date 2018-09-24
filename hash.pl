#!/usr/bin/perl

use strict;
use warnings;

# initialize variables
my $script = $0;
my $loc = shift || ".";
my $hash_bin = "md5sum";

# check argument
die "Error: $loc is not a directory" unless -d $loc;

# read dir
opendir(my $dir, $loc);
while(my $item = readdir $dir){

    # exclude ., .., and .git
    next if $item =~ /^(\.|\.\.)$|\.git/;

    # build path
    $loc = $loc . "/" unless substr($loc, -1) eq '/';
    my $itempath = "$loc$item";

    # traverse or hash
    if(-d $itempath){

	# traverse directory
	system($script, $itempath);
    } else {

	# calculate hash
	`$hash_bin $itempath` =~ /(^[\S]+)/;
	die "$hash_bin output could not be parsed" if not defined $1;
	my $hash = $1;

	# rename file
	system("mv", "$itempath", "$loc$hash");
    }
}
