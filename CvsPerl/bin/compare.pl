#!/usr/local/bin/perl

use FindBin qw($Bin);
use File::Spec;
use Data::Dumper;
BEGIN {
    my @directories = File::Spec->splitdir($Bin);
    pop @directories;
    my $lib = File::Spec->catdir(@directories);
    shift @INC, $lib;
}

use ExtUtils::testlib;
use CvsPerl qw(is_even);

CvsPerl::hello();

my $format = "is %s even: %s\n";
for my $i (0..4) {
	printf $format, $i, (is_even($i)) ? 'true' : 'false';	
}