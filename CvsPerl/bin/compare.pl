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
use CvsPerl qw(is_even round);

CvsPerl::hello();

my $format = "is %s even: %s\n";
for my $i (0..4) {
	printf $format, $i, (is_even($i)) ? 'true' : 'false';	
}

$format = "%-20s rounded: %s\n";
for my $i (1..4) {
	my $to_round = $i + ($i + 0.3)/3;
	my $rounded = $to_round;
	round($rounded);
	printf $format, $to_round, $rounded;	
}