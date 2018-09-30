#!/usr/bin/perl

use strict;
use warnings;

# initialize variables
my $loc = shift || "."; # location to traverse

# check location
die "Error: $loc is not a directory" unless -d $loc;

# check safety
print "WARNING: Flattening directory '$loc'. Continue? (y/N) ";
my $ok = <>; # ask for user input
if($ok ne "y\n"){
    print "Exiting.\n";
    exit;
}

# start traversing
flatten($loc);

sub flatten {

    # initialize
    my $loc = shift || ".";
    my $migrate = shift || "";

    # first pass: Recurse
    opendir(my $dir, $loc);
    while(my $item = readdir $dir){

        # canonize $loc and build path
        $loc = $loc . "/" unless substr($loc, -1) eq '/';
        my $itempath = "$loc$item";

        # skip non-directories
        next unless(-d $itempath);

        # skip . and ..
        next if $item =~ /^(\.|\.\.)$/;

        # remove .git recursively
        if($item eq ".git") {
            print("rm -rf '$itempath'\n");
            die if system("rm", "-rf", $itempath);
            next;
        }

        # traverse and remove
        flatten($itempath, 1);
        die if system("rmdir", "$itempath");
    }
    closedir($dir);

    # second pass: Migrate
    if($migrate) {
        opendir($dir, $loc);
        while(my $item = readdir $dir){

            # canonize $loc and build path
            $loc = $loc . "/" unless substr($loc, -1) eq '/';
            my $itempath = "$loc$item";

            # skip . and ..
            next if $item =~ /^(\.|\.\.)$/;

            # migrate files up
            print("mv '$itempath' '$loc..'\n");
            die if system("mv", "$itempath", "$loc..")
        }
    }
}
