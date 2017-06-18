#!/usr/bin/env perl
use strict;
use warnings;

use lib '/tmp/Benchmark_of_XS/blib/lib';
use lib '/tmp/Benchmark_of_XS/blib/arch';

use Benchmark
    qw(:hireswallclock cmpthese timethese timethis timediff timestr);
use Benchmark::of::XS;

my $string_xs = Benchmark::of::XS->new();

# split
my $count = 1000000;
my $delimiter = q{;};
my $string    = q{;ab;cd;ef;;};
my $results = timethese($count,
    {   'split perl'   => sub { $string_xs->split_perl($delimiter, $string) },
        'split xs'     => sub { $string_xs->split_xs($delimiter, $string) },
        'split native' => sub { split /$delimiter/, $string },
    },
    'all'
);

$count = 5000000;
$string    = q{abcdf};
my ($ofset, $length) = (2, 2);
$results = timethese($count,
    {   'substr perl'   => sub { $string_xs->substr_perl($string, $ofset, $length) },
        'substr xs'     => sub { $string_xs->substr_xs($string, $ofset, $length) },
        'substr native' => sub { substr $string, $ofset, $length },
    },
    'all'
);

