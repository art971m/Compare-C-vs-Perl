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
use CvsPerl;

CvsPerl::hello();