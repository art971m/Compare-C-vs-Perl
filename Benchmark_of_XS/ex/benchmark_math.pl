#!/usr/bin/env perl
use strict;
use warnings;

use lib '/tmp/Benchmark_of_XS/blib/lib';
use lib '/tmp/Benchmark_of_XS/blib/arch';

use Benchmark
    qw(:hireswallclock cmpthese timethese timethis timediff timestr);
use Benchmark::of::XS;
use GIS::Distance;
use GIS::Distance::Fast;

use Devel::Size qw(size total_size);
use Proc::ProcessTable;

use Data::Dumper;

my $math = Benchmark::of::XS->new();

# multiply
my $count = 10000000;
my ( $number1, $number2 ) = ( 1.2, 1.5 );
my $results = timethese($count,
    {   'multiplication perl' =>
            sub { $math->multiply_perl( $number1, $number2 ) },
        'multiplication xs' =>
            sub { $math->multiply_xs( $number1, $number2 ) },
    },
    'all'
);

# factorial
$count = 4000000;
$number1 = 20;
$results = timethese($count,
    {   'factorial perl' => sub { $math->factorial_perl($number1) },
        'factorial xs'   => sub { $math->factorial_xs($number1) },
    },
    'all'
);

